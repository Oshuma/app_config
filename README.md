# AppConfig [![Build Status](https://travis-ci.org/Oshuma/app_config.png?branch=master)](https://travis-ci.org/Oshuma/app_config) [![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3N885MZB7QCY6&lc=US&item_name=Dale%20Campbell&item_number=app_config&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)

An easy to use, customizable library to easily store and retrieve application
configuration; basically anything in 'key/value' pairs.

AppConfig requires at least Ruby 1.9.


## Usage

Usage is simple.  Just pass either a hash of options, or a block, to `AppConfig.setup!`.

In it's simplest form, you can use it like so:

```ruby
AppConfig.setup!(admin_email: 'admin@example.com')
# ..or..
AppConfig.setup! do |config|
  config.admin_email = 'admin@example.com'
end

AppConfig.admin_email  # => 'admin@example.com'
```

AppConfig also supports many different 'storage methods', such as YAML and MongoDB,
allowing you to tailor AppConfig to many different use cases.  For example,
storing your configuration in the same database as your development/production environment.


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

You can pass a `:mongo` options hash to `AppConfig.setup!` which should contain
configuration values for a Mongo database.  Check the `AppConfig::Storage::Mongo::DEFAULTS`
constant for the default Mongo connection options.

The '[mongo](https://rubygems.org/gems/mongo)' gem is required in order to use Mongo storage.

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


## PostgreSQL

Using PostgreSQL is similar to a Mongo setup.
The only current requirement is that the table have a primary key named `id`.
All other columns are used as configuration keys.

The '[pg](https://rubygems.org/gems/pg)' gem is required in order to use Postgres storage.

**Note:** The database and schema must exist prior to calling `AppConfig.setup!`.

Given this schema:

```sql
CREATE TABLE app_config (
  id bigserial NOT NULL PRIMARY KEY,
  admin_email character varying(255) DEFAULT 'admin@example.com'::character varying,
  api_key character varying(255) DEFAULT 'SOME_API_KEY'::character varying
);
```

Setup AppConfig:

```ruby
# These are the defaults.
postgres_opts = {
  host:     'localhost',
  port:     5432,
  dbname:   'app_config',
  table:    'app_config',

  # If these are nil (or omitted), the PostgreSQL defaults will be used.
  user:     nil,
  password: nil,
}

AppConfig.setup!(postgres: postgres_opts)

AppConfig.admin_email  # => 'admin@example.com'

# Override an existing value and save to the database:
AppConfig.admin_email = 'another_admin@example.com'
AppConfig.save!
```


## MySQL

Using MySQL is similar to Postgres, including the required primary key named `id`.
All other columns are used as configuration keys.

The '[mysql2](https://rubygems.org/gems/mysql2)' gem is required in order to use MySQL storage.

**Note:** The database and schema must exist prior to calling `AppConfig.setup!`.

Given this schema:

```sql
CREATE TABLE app_config (
 id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
 admin_email VARCHAR(255) DEFAULT "admin@example.com",
 api_key VARCHAR(255) DEFAULT "SOME_API_KEY",
 true_option BOOLEAN DEFAULT true,
 false_option BOOLEAN DEFAULT false
);
```

Setup AppConfig:

```ruby
# These are the defaults:
mysql_opts = {
  host: 'localhost',
  port: 3306,
  database: 'app_config',
  table: 'app_config',
  username: nil,
  password: nil,
}

AppConfig.setup!(mysql: mysql_opts)

AppConfig.admin_email  # => 'admin@example.com'

# Update an existing value and save changes:
AppConfig.admin_email = 'another_admin@example.com'
AppConfig.save!
```


## SQLite

SQLite storage works the same as the other SQL storage methods, including the mandatory
primary key `id` column.

The '[sqlite3](https://rubygems.org/gems/sqlite3)' gem is required in order to use SQLite storage.

**Note:** The database schema must exist prior to calling `AppConfig.setup!`.

```ruby
# These are the defaults:
sqlite_opts = {
  database: File.join(Dir.home, '.app_config.sqlite3'),
  table: 'app_config',
}

AppConfig.setup!(sqlite: sqlite_opts)
```


## Using Storage Defaults

All storage options accept `true` as a value, which uses the default options for that storage.

For example, to use the [Mongo](lib/app_config/storage/mongo.rb#L9) defaults:

```ruby
AppConfig.setup!(mongo: true)
```

### Storage Defaults

* [Mongo](lib/app_config/storage/mongo.rb#L9)
* [MySQL](lib/app_config/storage/mysql.rb#L8)
* [Postgres](lib/app_config/storage/postgres.rb#L8)
* [SQLite](lib/app_config/storage/sqlite.rb#L9)
* [YAML](lib/app_config/storage/yaml.rb#L9)


### Environment Mode

The YAML storage method provides an `:env` option where you can organize the config like Rails `database.yml`:

```yaml
# Rails.root/config/app_config.yml
development:
  title: 'Development Mode'

production:
  title: 'Production Mode'
```

Pass a string or symbol to the `:env` option.

```ruby
# Rails.root/config/initializers/app_config.rb
AppConfig.setup!({
  yaml: "#{Rails.root}/config/app_config.yml",
  env: Rails.env
})

# Uses the given environment section of the config.
AppConfig.title  # => 'Production Mode'
```


## Deprecation Note

Version `2.x` is **not** backwards compatible with the `1.x` branch.

See the [wiki](https://github.com/Oshuma/app_config/wiki) for current usage instructions.
