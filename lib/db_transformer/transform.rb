module DbTransformer
  class Transform
    def self.execute!(*args)
      new(*args).execute!
    end

    def initialize(table_name, row, rules)
      @table_name = table_name
      @row = row
      @rules = rules
    end

    def execute!
      return @row unless match_rules?

      applicable_rules.inject(@row) do |row, rule|
        rule_model = Rules.const_get(rule['type'].split('_').map(&:capitalize).join, false)
        rule_model.apply(rule['mode'], row, rule['column'], rule)
      end
    end

    def match_rules?
      applicable_rules.any?
    end

    def applicable_rules
      @applicable_rules ||= @rules.select do |rule|
        @table_name.to_s == rule['table']
      end
    end
  end
end
