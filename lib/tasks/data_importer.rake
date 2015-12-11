namespace :db do
  namespace :sync do
    desc 'This task updates the local development database with the production data from Heroku'
    task :local, [:heroku_config_database_url] => :environment do |_t, args|
      UI.start 'Syncing the local database from the heroku production one...' do
        UI.heading 'Getting the heroku database url...'
        match_database(args[:heroku_config_database_url])

        UI.heading 'Copying the latest data from the production site...'
        get_remote_data

        UI.heading 'Importing the data in the local database...'
        set_local_data
      end
    end

    desc 'This task updates the staging database with the production data from Heroku'
    task staging: :environment do
      UI.start 'Syncing the staging database with the produciton data from Heroku...' do
        staging_app_name = app_name('staging')
        system "heroku pg:copy #{app_name}::DATABASE_URL DATABASE_URL -a #{staging_app_name} --confirm #{staging_app_name}"
      end
    end

    private

    def match_database(database_url)
      database_url ||= `heroku config:get DATABASE_URL -a #{app_name}`.chomp
      @db = database_url.match(%r{^postgres://(.*?):(.*?)@(.*?):\d*?/(.*?)$})
      fail "Invalid database url format" unless @db
      UI.message @db
    end

    def get_remote_data
      @export_file = File.join('tmp', 'db-data-dump.sql')
      system "export PGPASSWORD=\"#{@db[2]}\"; pg_dump -U#{@db[1]} -h#{@db[3]} -a -Tschema_migrations #{@db[4]} > #{@export_file}"
      UI.message "DB dump temporarily saved at: #{@export_file}"
    end

    def set_local_data
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      database = Rails.configuration.database_configuration[Rails.env]['database']
      system "psql -h localhost #{database} -f #{@export_file}"
      `rm #{@export_file}`
    end

    def app_name(remote_name = 'heroku')
      `git remote -v`.split("\n").map do |remote|
        remote.match(%r{^#{remote_name}\s+(?:https:\/\/)?git[@\.]heroku\.com[:\/](?<app_name>.+)\.git\s+\(push\)})
      end.compact.first[:app_name]
    end
  end
end
