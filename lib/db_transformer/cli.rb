require 'thor'

module DbTransformer
  class CLI < Thor
    desc 'apply', 'Copy data from source to destination and transform the destination data'

    option :config
    def apply
      config = YAML.load(File.read(options[:config]))

      Synchronizer.new(config).execute!
    end
  end
end
