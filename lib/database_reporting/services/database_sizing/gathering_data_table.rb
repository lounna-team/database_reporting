module DatabaseReporting
  module Services
    module DatabaseSizing
      class GatheringDataTable

        def initialize
        end

        def perform
          tables = ActiveRecord::Base.connection.tables
          result_table_infos = []

          tables.each do |table|
            begin
              klass = table.singularize.camelize.constantize
              
              result_table_infos << {
                table_name: klass.name,
                table_size: "DatabaseReporting::Services::DatabaseSizing.TableSizeService.new(table: table).perform",
                table_nb_lines: klass.count,
                table_last_entry: klass.order(updated_at: :desc).first.updated_at.strftime("%d/%m/%Y")
              }

            rescue
              next
            end
          end

          return result_table_infos
        end

      end
    end
  end
end