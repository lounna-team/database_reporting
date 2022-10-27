module DatabaseReporting
  module Presenter
    # Presenter for data reporting
    class DatabaseReportingPresenter
      attr_accessor :reporting_hash, :reporting_return

      def initialize
        @reporting_hash = datas
        @reporting_return = ''
      end

      def call
        total_db_size = reporting_hash[0][:db_name]
        puts "TOTAL DB SIZE : #{total_db_size} \n"
        tables = reporting_hash[1]
        tables.each do |table|
          puts "\nTABLE_NAME : #{table[:table_name]}\n  TABLE_SIZE : #{table[:table_size]}\n  TABLE_NB_LINES : #{table[:table_nb_lines]}\n  TABLE_LAST_ENTRY : #{table[:table_last_entry]}\n"
        end
        return 'END'
      end

      private

      def datas
        [
          { db_name: DatabaseReporting::Services::DatabaseSizing::DatabaseSizeService.new.perform },
          DatabaseReporting::Services::DatabaseSizing::GatheringDataTable.new.perform
        ]
      end
    end
  end
end
