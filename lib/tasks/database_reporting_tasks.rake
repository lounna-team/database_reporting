namespace :database_reporting do
  desc "Explaining what the task does"
  task :database_sizing => :environment do
 #   data = DatabaseReporting::Services::DatabaseSizing::DatabaseSizeService.new.perform
 #   data2 = DatabaseReporting::Services::DatabaseSizing::TableSizeService.new(table: 'users').perform
   # data3 = DatabaseReporting::Services::DatabaseSizing::GatheringDataTable.new.perform
  #  puts data
  #  puts data2
    #puts data3
    DatabaseReporting::Presenter::DatabaseReportingPresenter.new.call
  end
end
