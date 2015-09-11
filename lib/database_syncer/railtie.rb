module DatabaseSyncer
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/data_importer.rake'
    end
  end
end
