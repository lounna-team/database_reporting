puts "#{klass.name} has #{klass.order(updated_at: :desc).first.updated_at} "
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
                table_size:
                table_nb_ligne: klass.count,
                table_last_entry: klass.order(updated_at: :desc).first.updated_at
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