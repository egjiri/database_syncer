require 'database_syncer/version'

module DatabaseSyncer
  require 'database_syncer/railtie' if defined?(Rails)
end
