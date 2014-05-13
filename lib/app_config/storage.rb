module AppConfig
  module Storage
    autoload :Base,       'app_config/storage/base'
    autoload :ConfigData, 'app_config/storage/config_data'
    autoload :Mongo,      'app_config/storage/mongo'
    autoload :MySQL,      'app_config/storage/mysql'
    autoload :Postgres,   'app_config/storage/postgres'
    autoload :SQLite,     'app_config/storage/sqlite'
    autoload :YAML,       'app_config/storage/yaml'
  end
end
