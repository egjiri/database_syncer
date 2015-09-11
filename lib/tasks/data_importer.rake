namespace :db do
  namespace :sync do
    desc 'This task updates the local development database with the production data from Heroku'
    task :local, [:heroku_config_database_url] => :environment do |_t, args|
      if args[:heroku_config_database_url]
        puts "Copying the latest data from the production site... [#{Time.current}]".color(:cyan)
        get_remote_data(args[:heroku_config_database_url])
        puts "Importing the data in the local database... [#{Time.current}]".color(:green)
        set_local_data
        puts 'Finished Importing the Data.'.color(:magenta)
      else
        puts 'You need to pass in the heroku_config_database_url argument to the rake task'.color(:red)
        puts '$ heroku config:get DATABASE_URL -a app-name'.color(:white)
        puts 'copy the DATABASE_URL variable and then call the rake task again'.color(:yellow)
        puts '$ rake db:sync:local["postgres://svym..."]'.color(:white)
      end
    end

    private

    def get_remote_data(heroku_config_database_url)
      @export_file = File.join('tmp', 'db-data-dump.sql')
      db = heroku_config_database_url.match(%r{^postgres://(.*?):(.*?)@(.*?):\d*?/(.*?)$})
      system "export PGPASSWORD=\"#{db[2]}\"; pg_dump -U#{db[1]} -h#{db[3]} -a -Tschema_migrations #{db[4]} > #{@export_file}"
    end

    def set_local_data
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      database = Rails.configuration.database_configuration[Rails.env]['database']
      system "psql -h localhost #{database} -f #{@export_file}"
      `rm #{@export_file}`
    end
  end
end
