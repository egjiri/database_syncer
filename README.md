# DatabaseSyncer

This gem provides a rake task to simply sync the local database with the production database on Heroku. The gem in meant to be used on a Rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'database_syncer'
```

And then execute:

    $ bundle

## Usage

From the root of your rails run:
```console
rake db:sync:local["postgres://..."]
```
The "postgres://..." sting should be your Heroku DATABASE_URL and can be found by running this command:
```console
heroku config:get DATABASE_URL -a app-name
```
---
You can also get these instructions by running:
```console
rake db:sync:local
```
Which will output:
```console
You need to pass in the heroku_config_database_url argument to the rake task
$ heroku config:get DATABASE_URL -a app-name
copy the DATABASE_URL variable and then call the rake task again
$ rake db:sync:local["postgres://svym..."]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
