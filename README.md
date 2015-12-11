# DatabaseSyncer

This gem provides a rake task to simply sync the local Postgres database with the production database on Heroku. The gem in meant to be used on a Rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'database_syncer'
```

And then execute:

    $ bundle

## Requirements
Git remotes on the specific app this gem is included in are used to determine the app names for the heroku production and staging apps.

##### Remotes must be named as follows:
* heroku (for production which is the default)
* staging (for staging)

## Usage

##### Sync the local database from the heroku production database:
```console
rake db:sync:local
```

##### Sync the staging heroku database from the heroku production database:
```console
rake db:sync:staging
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
