module AppConfig
  module Storage
    autoload :Memory, 'app_config/storage/memory'
    autoload :Sqlite, 'app_config/storage/sqlite'
    autoload :YAML,   'app_config/storage/yaml'
  end
end
