module ApiStore
  # YAML storage method.
  class Yaml
    attr_reader :data

    # Loads @data with the YAML file located at +path+.
    def initialize(path)
      @data = YAML.load_file(path)
    end

    # Creates a new Yaml storage with the given +path+ and returns the data.
    def self.load(path)
      new(path).data
    end

  end # Yaml

end # ApiStore
