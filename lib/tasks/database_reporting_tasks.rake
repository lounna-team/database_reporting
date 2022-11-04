namespace :database_reporting do
  desc 'Task that returns a report of the size of the db and tables inside it'
  task database_sizing: :environment do
    # data = DatabaseReporting::Services::DatabaseSizing::DatabaseSizeService.new.perform
    # data2 = DatabaseReporting::Services::DatabaseSizing::TableSizeService.new(table: 'users').perform
    # data3 = DatabaseReporting::Services::DatabaseSizing::GatheringDataTable.new.perform
    # puts data
    # puts data2
    # puts data3
    DatabaseReporting::Presenter::DatabaseReportingPresenter.new.perform
  end

  desc 'Task that returns if a table is correctly created'
  task table_reporting: :environment do
    # TODO : add a service to loop on tables of the database
    DatabaseReporting::Presenter::TablesReportinngPresenter.new.perform
  end
end
