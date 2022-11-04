module DatabaseReporting
  module Services
    # module to gather infos on a table
    module ReportingTables
      # Class that gathers all columns of a table
      class GatheringTableColumns
        attr_accessor :table_name

        def initialize(table_name:)
          @table_name = table_name
        end

        def perform
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
