module DbTransformer
  module Rules
    class Rename
      class << self
        def apply(mode, row, column, options)
          case mode
          when 'template'
            template(row, column, options['template'])
          end
        end

        # @param [Hash] row
        # @param [String] column
        # @param [String] template
        def template(row, column, template)
          row.tap do |t|
            t[column.to_sym] = template % row
          end
        end
      end
    end
  end
end
