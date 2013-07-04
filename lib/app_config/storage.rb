module AppConfig
  module Storage
    autoload :Base,     'app_config/storage/base'
    autoload :Mongo,    'app_config/storage/mongo'
    autoload :Postgres, 'app_config/storage/postgres'
    autoload :YAML,     'app_config/storage/yaml'
  end
end
