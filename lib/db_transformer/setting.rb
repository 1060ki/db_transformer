module DbTransformer
  module Setting
    module_function

    # @param [String] file_path
    # @return [Hash]
    def load(file_path)
      file_body = File.read(file_path)

      YAML.load(ERB.new(file_body).result)
    end
  end
end
