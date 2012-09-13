# AppConfig [![Build Status](https://secure.travis-ci.org/DSIW/app_config.png)](http://travis-ci.org/DSIW/app_config)
[![Dependency Status](https://gemnasium.com/DSIW/app_config.png)](https://gemnasium.com/DSIW/app_config)

An easy to use, customizable library to easily store and retrieve application
(or library) configuration, API keys or basically anything in 'key/value' pairs.


## Usage

Usage is simple.  Just pass either a hash of options, or a block, to {AppConfig.setup}.

In it's simplest form, you can use it like so:

    AppConfig.setup(:admin_email => 'admin@example.com')
    # ..or..
    AppConfig.setup do |config|
      config[:admin_email] = 'admin@example.com'
    end

    # Strings or symbols as keys.
    AppConfig[:admin_email] # => 'admin@example.com'

You may also specify the storage method along with options specific to that storage method.
Check the [wiki](https://github.com/Oshuma/app_config/wiki) for more usage examples.

## Deprecation Note

Version `1.0` is \***not**\* backwards compatible with `0.7.1`!  See the [wiki](https://github.com/Oshuma/app_config/wiki)
for upgrade instructions.


## AppConfig::Storage::YAML

Given this YAML file:

    ---
    admin_email: 'admin@example.com'
    api_name:    'Supr Webz 2.0'
    api_key:     'SUPERAWESOMESERVICE'

Use it like so:

    AppConfig.setup(:yaml => '/path/to/app_config.yml')

    # Later on...
    # Strings or symbols as keys.
    AppConfig['admin_email'] # => 'admin@example.com'
    AppConfig[:api_name]     # => 'Supr Webz 2.0'
    AppConfig[:api_key]      # => 'SUPERAWESOMESERVICE'


## AppConfig::Storage::Mongo

You can pass a `:mongo` options hash to {AppConfig.setup} which should contain
configuration values for a Mongo database.  Check the {AppConfig::Storage::Mongo::DEFAULTS}
constant for the default Mongo connection options.

    mongo_opts = {
      :host       => 'localhost',   # default
      :database   => 'app_config',  # default
      :collection => 'app_config'   # default
    }

    AppConfig.setup(:mongo => mongo_opts)

    AppConfig[:admin_email]
    # => 'admin@example.com'

    # Override an existing value (saves to the database):
    AppConfig[:admin_email] = 'other_admin@example.com'

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
    AppConfig.setup({
      :yaml => "#{Rails.root}/config/app_config.yml",
      :env  => Rails.env  # or any string
    })

    # Uses the given environment section of the config.
    AppConfig[:title]
    # => 'Production Mode'

