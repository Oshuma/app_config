module AppConfig
  module Storage
    autoload :Sqlite, 'app_config/storage/sqlite'
    autoload :Yaml, 'app_config/storage/yaml'
  end
end
