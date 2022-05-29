module DbTransformer
  class Synchronizer
    LIMIT = 1000

    def initialize(settings)
      @settings = settings
    end

    def execute!
      destination_database_client.run('SET foreign_key_checks = 0;')

      tables.each do |table_name|
        logger.info("Start copying `#{table_name}`")

        if @settings['destination']['options']['force_replace']
          destination_database_client.run("DROP TABLE #{table_name}")
        end

        create_table_query = source_database_client.fetch('SHOW CREATE TABLE ?', table_name).first[:'Create Table']
        create_table_query = create_table_query.gsub('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS')
        destination_database_client.run(create_table_query)

        offset = 0
        loop do
          data = source_database_client[table_name].limit(LIMIT, offset)

          table = destination_database_client[table_name]
          data.each { |row| table.insert(Transform.execute!(table_name, row, rules)) }

          break if data.none?

          offset += LIMIT
        end

        logger.info("Copied `#{table_name}`")
      end

      destination_database_client.run('SET foreign_key_checks = 1;')
    rescue Sequel::DatabaseConnectionError => e
      if e.message.include?('Unknown database')
        destination_database_client_without_db.run("CREATE DATABASE `#{@settings['destination']['database']}`")

        retry
      end

      raise
    end

    private

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def tables
      source_database_client.tables
    end

    def source_database_client
      @source_database_client ||= Sequel.mysql2(@settings['source'])
    end

    def destination_database_client
      @destination_database_client ||= Sequel.mysql2(destination_database_settings)
    end

    def destination_database_client_without_db
      @destination_database_client_without_db ||= Sequel.mysql2(destination_database_settings.reject { |k, _| k == 'database' })
    end

    def destination_database_settings
      @destination_database_settings ||= @settings['destination'].reject { |k, _| k == 'options' }
    end

    def rules
      @settings['rules']
    end
  end
end
