require "database_reporting/version"
require "database_reporting/railtie"

module DatabaseReporting
  class Railtie < Rails::Railtie
    rake_tasks do
      load("tasks/database_reporting_tasks.rake")
    end
  end
end
