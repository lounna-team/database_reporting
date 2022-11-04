module DatabaseReporting
  module Presenter
    # Class that presents the report of a table
    class TablesReportingPresenter < BasePresenter
      def perform
        all_tables_columns_datas = datas
        all_tables_columns_datas.each do |table_column_data|
          puts table_column_data[:table_name]
          columns_infos = table_column_data[:result_columns_infos]
          columns_infos.each do |column_infos|
            next unless column_infos[:column_sql_type] == 'boolean' || column_infos[:column_sql_type] == 'integer'

            # TODO : change the presentation of the line and add a counter of the number of "errors" on the table
            puts check_column_validity(column_infos: column_infos)
          end
        end
      end

      private

      def check_column_validity(column_infos:)
        return text_red(column_infos.to_s) if column_infos[:column_nullable] || column_infos[:column_default_value].blank?

        text_green(column_infos.to_s)
      end

      def datas
        DatabaseReporting::Services::ReportingTables::GatheringTableColumns.new.perform
      end
    end
  end
end
