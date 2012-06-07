module AppConfig
  module Storage
    autoload :Base,   'app_config/storage/base'
    autoload :Memory, 'app_config/storage/memory'
    autoload :Mongo,  'app_config/storage/mongo'
    autoload :YAML,   'app_config/storage/yaml'
  end
end
