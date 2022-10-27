namespace :database_reporting do
  desc "Explaining what the task does"
  task :database_sizing => :environment do
    DatabaseReporting::Services::DatabaseSizing::GatheringDataService.new(database_name: 'test').perform
  end
end
