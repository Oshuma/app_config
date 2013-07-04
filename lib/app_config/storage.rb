module AppConfig
  module Storage
    # Used when creating a new, infinitely nested Hash.
    DEEP_HASH = lambda { |h, k| h[k] = Hash.new(&h.default_proc) }

    autoload :Base,     'app_config/storage/base'
    autoload :Mongo,    'app_config/storage/mongo'
    autoload :Postgres, 'app_config/storage/postgres'
    autoload :YAML,     'app_config/storage/yaml'
  end
end
