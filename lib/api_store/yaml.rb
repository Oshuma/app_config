module ApiStore
  class Yaml
    attr_reader :data

    def initialize(path)
      @data = load_file(path)
    end

    def self.load(opts)
      new(opts).data
    end

  private

    def load_file(path)
      YAML.load_file(path)
    end

  end # Yaml

end # ApiStore
