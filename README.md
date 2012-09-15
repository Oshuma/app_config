# AppConfig [![Build Status](https://secure.travis-ci.org/DSIW/app_config.png)](http://travis-ci.org/DSIW/app_config) [![Dependency Status](https://gemnasium.com/DSIW/app_config.png)](https://gemnasium.com/DSIW/app_config)

An easy to use, customizable library to easily store and retrieve application
(or library) configuration, API keys or basically anything in 'key/value' pairs.


## Usage

Usage is simple.  Just pass either a hash of options, or a block, to {AppConfig.setup}.

In it's simplest form, you can use it like so:

    config = AppConfig.setup do |config|
      config[:admin_email] = 'admin@example.com'
      # Other setter:
      # config["admin_email"] = 'admin@example.com'
      # config.admin_email = 'admin@example.com'
    end

    # Strings or symbols or dynamic methods as keys.
    config[:admin_email]  #=> 'admin@example.com'
    config["admin_email"] #=> 'admin@example.com'
    config.admin_email    #=> 'admin@example.com'

You may also specify the storage method along with options specific to that storage method.
Check the [wiki](https://github.com/Oshuma/app_config/wiki) for more usage examples.

If you like to use the {AppConfig::Configurable} module, see how easy it is:

    module Client
      include Configurable

      def set_config
        # Use it everywhere you want
        config.api_url     = "http://example.com/api/"
        config.api_key     = "2H28dsaa4"
        config.api_version = "2"
      end
    end

Please scroll down to the last chapter for more informtation and details.


## Deprecation Note

Version `2.0` is ***not*** backwards compatible with `1.0` and `0.7.1`!  See the [wiki](https://github.com/Oshuma/app_config/wiki)
for upgrade instructions.


## AppConfig::Storage::YAML

Given this YAML file:

    ---
    admin_email: 'admin@example.com'
    api_name:    'Supr Webz 2.0'
    api_key:     'SUPERAWESOMESERVICE'

Use it like so:

    config = AppConfig.setup(:yaml => '/path/to/app_config.yml')

    # Later on...
    # Strings or symbols or dynamic methods as keys.
    config['admin_email'] #=> 'admin@example.com'
    config.api_name       #=> 'Supr Webz 2.0'
    config[:api_key]      #=> 'SUPERAWESOMESERVICE'

### Create the YAML file, if it doesn't exist

I like to create the YAML file, if it doesn't exist

    config = AppConfig.setup(:yaml => '/path/to/file_doesnt_exist.yml', :create => true)
    # File will be created with all non-existing directories.

    # Later on...
    config['admin_email'] = 'admin@example.com'
    config['admin_email'] #=> 'admin@example.com'

### Save all changes automatically

When you use your config sometimes, it would be nice, if your config will be saved automatically to your YAML file.

    config = AppConfig.setup(:yaml => '/path/to/app_config.yml', :save_changes => true)

    # Later on...
    config['admin_email'] #=> 'admin@example.com'
    # YAML file will be written and includes 'admin_email'.

## AppConfig::Storage::Mongo

You can pass a `:mongo` options hash to {AppConfig.setup} which should contain
configuration values for a Mongo database.  Check the {AppConfig::Storage::Mongo::DEFAULTS}
constant for the default Mongo connection options.

    mongo_opts = {
      :host       => 'localhost',   # default
      :database   => 'app_config',  # default
      :collection => 'app_config'   # default
    }

    config = AppConfig.setup(:mongo => mongo_opts)

    config[:admin_email] #=> 'admin@example.com'

    # Override an existing value (saves to the database):
    config[:admin_email] = 'other_admin@example.com'

The values are read/saved (by default) to the `app_config` database and
`app_config` collection.  These defaults can be overridden, however, which
might lend well to versioned configurations; collection names such as
`app_config_v1`, `app_config_v2`, etc.

    AppConfig.setup(:mongo => { :collection => 'app_config_v2' })

## Environment Mode

There's also an 'environment mode' where you can organize the config
sort of like the Rails database config. Given this YAML file:

    # Rails.root/config/app_config.yml
    development:
      title: 'Development Mode'

    production:
      title: 'Production Mode'

Set the `:env` option to your desired environment.

    # Rails.root/config/initializers/app_config.rb
    config = config.setup({
      :yaml => "#{Rails.root}/config/app_config.yml",
      :env  => Rails.env  # or any string
    })

    # Uses the given environment section of the config.
    config[:title]
    # => 'Production Mode'

## Module Configurable

You can include the module `Configurable` to have access to your configuration in all your code.
This module is created to include it in all classes where you want to have access to your configuration.


### Forcing or reloading

Your access by _config_ is cached. So if you'd like to have another object, you could do this by passing :force or :reload.

    config.object_id #=> 123456
    config(:force => true).object_id #=> 654321
    # ..or..
    config(:reload => true)

#### New object, because :force is set
    config(:force => true)

#### New object, because :force is set and block is given
    config(:force => true) { |config| config[:key] = "value" }

#### New object, because :force isn't set and block is given
    config { |config| config[:key] = "value" }

#### No new object, because :force is false and block is given
    config(:force => false) { |config| config[:key] = "value" }

#### Creates a new object and YAML file will be empty
    config(:yaml => "path/to/file.yml", :force => true, :save_changes => true)
    File.read("path/to/file.yml") #=> "--- {}"

See {AppConfig::Configurable#config} for datails.
