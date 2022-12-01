module DatabaseReporting
  module Services
    module DatabaseSizing
      class ColumnDataService

        def initialize
        end

        def call
          ActiveRecord::Base.connection.tables.each do |table|
            begin
              puts "--->#{table.upcase}<---"
              columns = get_column_infos_from_table(table)
              columns.each do |data|
                puts data[:column].upcase
                puts "\n"
                puts "Nombre de valeur nil: #{data[:number_of_nil_values].to_i} => #{data[:number_of_nil_values].to_f/(data[:number_of_nil_values].to_i + data[:number_of_not_nil_values].to_i)*100.to_f}%"
                puts "Nombre de valeur non nil: #{data[:number_of_not_nil_values].to_i} => #{data[:number_of_not_nil_values].to_f/(data[:number_of_nil_values].to_i + data[:number_of_not_nil_values].to_i)*100.to_f}%"
                puts "Nombre de valeur différentes: #{data[:number_of_différent_values]}"
                puts "Pourcentage des valeurs différentes: #{data[:proportion_values_in_column]}"
                puts "-----------\n"
                puts "\n"
              end
            rescue
              next
            end
          end

          "END"
        end

        private

        def get_column_infos_from_table(table)
          klass = table.singularize.camelize.constantize
          columns = klass.column_names
          column_informations = []
          columns.each do |col|
            column_informations << {
              table: klass,
              column: col,
              number_of_nil_values: klass.where("#{col} IS ?", nil).size,
              number_of_not_nil_values: klass.where("#{col} IS NOT ?", nil).size,
              number_of_différent_values: get_all_values_from_column(col, klass).size,
              proportion_values_in_column: get_proportion_values_in_column(col, klass)
            }
          end

          return column_informations
        end

        def get_all_values_from_column(col, klass)
          @all_values_from_column = klass.pluck(col.to_sym).tally
        end

        def get_proportion_values_in_column(col, klass)
          nb_total_entry = klass.pluck(col.to_sym).count
          return "Not intteresting for the numbers of different values( > 15 )" unless nb_total_entry <= 15

          @all_values_from_column.map do |k,v|
            "Value: #{k.nil? ? "nil" : k} / Pourcentage: #{v.to_f/nb_total_entry*100} %"
          end
        end
      end
    end
  end
end
