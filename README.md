# AppConfig [![Build Status](https://travis-ci.org/Oshuma/app_config.png?branch=master)](https://travis-ci.org/Oshuma/app_config) [![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3N885MZB7QCY6&lc=US&item_name=Dale%20Campbell&item_number=app_config&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)

An easy to use, customizable library to easily store and retrieve application
(or library) configuration, API keys or basically anything in 'key/value' pairs.

AppConfig requires at least Ruby 1.9.


## Usage

Usage is simple.  Just pass either a hash of options, or a block, to {AppConfig.setup!}.

In it's simplest form, you can use it like so:

```ruby
AppConfig.setup!(admin_email: 'admin@example.com')
# ..or..
AppConfig.setup! do |config|
  config.admin_email = 'admin@example.com'
end

AppConfig.admin_email  # => 'admin@example.com'
```

You may also specify the storage method along with options specific to that storage method.
Check the [wiki](https://github.com/Oshuma/app_config/wiki) for more usage examples.


## YAML

Given this YAML file:

```yaml
---
admin_email: 'admin@example.com'
api_name:    'Supr Webz 2.0'
api_key:     'SUPERAWESOMESERVICE'
```

Use it like so:

```ruby
AppConfig.setup!(yaml: '/path/to/app_config.yml')

# Later on...
AppConfig.admin_email  # => 'admin@example.com'
AppConfig.api_name     # => 'Supr Webz 2.0'
AppConfig.api_key      # => 'SUPERAWESOMESERVICE'
```


## Mongo

You can pass a `:mongo` options hash to {AppConfig.setup!} which should contain
configuration values for a Mongo database.  Check the {AppConfig::Storage::Mongo::DEFAULTS}
constant for the default Mongo connection options.

```ruby
# These are the defaults.
mongo_opts = {
  host:       'localhost',
  database:   'app_config',
  collection: 'app_config'
}

AppConfig.setup!(mongo: mongo_opts)

AppConfig.admin_email  # => 'admin@example.com'

# Override an existing value and save to the database:
AppConfig.admin_email = 'other_admin@example.com'
AppConfig.save!
```

The values are read/saved (by default) to the `app_config` database and
`app_config` collection.  These defaults can be overridden, however, which
might lend well to versioned configurations; collection names such as
`app_config_v1`, `app_config_v2`, etc.

```ruby
AppConfig.setup!(mongo: { collection: 'app_config_v2' })
```


## Deprecation Note

Version `2.0` is **not** backwards compatible with the `1.x` branch.

See the [wiki](https://github.com/Oshuma/app_config/wiki) for upgrade instructions.
