module DatabaseReporting
  module Services
    # module to gather infos on a table
    module ReportingTables
      # Class that gathers all columns of a table
      class GatheringTableColumns
        def perform
          result_gathering_tables_columns = []
          Rails.application.eager_load!
          descendants = ActiveRecord::Base.descendants.collect(&:name)
          descendants.shift(1)
          descendants.pop(9)
          descendants.each do |table_name|
            result_gathering_tables_columns << retrieve_all_columns_infos(table_name: table_name)
          end
          result_gathering_tables_columns
        end

        private

        def retrieve_all_columns_infos(table_name:)
          result_columns_infos = []
          columns_array = table_name.constantize.columns
          columns_array.each do |column|
            result_columns_infos << {
              column_name: column.name, column_sql_type: column.sql_type_metadata.sql_type,
              column_nullable: column.null, column_default_value: column.default.presence
            }
          end
          { table_name: table_name, result_columns_infos: result_columns_infos }
        end
      end
    end
  end
end
