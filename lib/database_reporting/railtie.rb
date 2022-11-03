require 'database_reporting/presenter/base_presenter'
require 'database_reporting/presenter/database_reporting_presenter'
require 'database_reporting/services/database_sizing/gathering_data_table'
require 'database_reporting/services/database_sizing/database_size_service'
require 'database_reporting/services/database_sizing/table_size_service'

module DatabaseReporting
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/database_reporting_tasks.rake'
    end
  end
end
