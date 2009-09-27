module AppConfig
  module Storage
    autoload :Sqlite, 'app_config/storage/sqlite'
    autoload :YAML, 'app_config/storage/yaml'
  end
end
