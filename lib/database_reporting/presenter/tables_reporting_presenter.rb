module DatabaseReporting
  module Presenter
    # Class that presents the report of a table
    class TablesReportinngPresenter < BasePresenter
      def perform
        table_name = datas[:table_name]
        columns_infos = datas[:result_columns_infos]
        puts table_name
        columns_infos.each do |column_infos|
          next unless column_infos[:column_sql_type] == 'boolean' || column_infos[:column_sql_type] == 'integer'

          # TODO : change the presentation of the line and add a counter of the number of "errors" on the table
          puts check_column_validity(column_infos: column_infos)
        end
      end

      private

      def check_column_validity(column_infos:)
        return text_red(column_infos.to_s) if column_infos[:column_nullable] || column_infos[:column_default_value].blank?

        text_green(column_infos.to_s)
      end

      def datas
        DatabaseReporting::Services::ReportingTables::GatheringTableColumns.new(table_name: 'Employee').perform
      end
    end
  end
end
