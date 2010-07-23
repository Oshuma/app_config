module AppConfig
  module Storage
    autoload :BaseStorage, 'app_config/storage/base_storage'
    autoload :Memory,      'app_config/storage/memory'
    autoload :MongoDB,     'app_config/storage/mongo'
    autoload :Sqlite,      'app_config/storage/sqlite'
    autoload :YAML,        'app_config/storage/yaml'
  end
end
