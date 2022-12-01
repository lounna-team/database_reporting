module DatabaseReporting
  # Presenter module
  module Presenter
    attr_accessor :total_number_of_columns, :total_number_of_errored_columns

    # Class that presents the report of a table
    class TablesReportingPresenter < BasePresenter
      def initialize
        super
        @total_number_of_columns = 0
        @total_number_of_errored_columns = 0
        @total_number_of_enums = 0
        @total_number_of_errored_enums = 0
      end

      def perform
        all_tables_columns_datas = datas
        all_tables_columns_datas.each do |table_column_data|
          puts text_light_blue("TABLE #{table_column_data[:table_name]}")
          if table_column_data[:table_name].constantize.defined_enums.blank?
            puts 'Table has no enums'
          end
          columns_infos = table_column_data[:result_columns_infos]
          columns_infos.each do |column_infos|
            @total_number_of_columns += 1
            if column_infos[:column_sql_type] == 'boolean' || column_infos[:column_sql_type] == 'integer'
              @total_number_of_errored_columns += column_errored?(column_infos: column_infos)
              if table_column_data[:table_name].constantize.defined_enums.key?(column_infos[:column_name])
                @total_number_of_enums += 1
                @total_number_of_errored_enums += column_errored?(column_infos: column_infos)
                puts check_enum_validity(column_infos: column_infos)
              else
                puts check_column_validity(column_infos: column_infos)
              end
            end
          end
          puts text_green('✅ Column fully checked')
          puts "\n\n"
        end

        percentage_enums_errors = percentage_errors(total: @total_number_of_enums, total_errors: @total_number_of_errored_enums)
        puts "TOTAL NUMBER OF ERRORED ENUMS : #{text_red(@total_number_of_errored_enums.to_s)} || TOTAL NUMBER OF ENUMS : #{@total_number_of_enums} || PERCENTAGE OF ERRORED ENUMS : #{display_percentage_errors(percentage_errors: percentage_enums_errors)}"

        percentage_columns_errors = percentage_errors(total: @total_number_of_columns, total_errors: @total_number_of_errored_columns)
        puts "TOTAL NUMBER OF ERRORED COLUMNS : #{text_red(@total_number_of_errored_columns.to_s)} || TOTAL NUMBER OF COLUMNS : #{@total_number_of_columns} || PERCENTAGE OF ERRORED COLUMNS : #{display_percentage_errors(percentage_errors: percentage_columns_errors)}"
      end

      private

      def display_percentage_errors(percentage_errors:)
        return text_red("#{percentage_errors}%") if percentage_errors > 25
        return text_yellow("#{percentage_errors}%") if percentage_errors.between?(10.to_f, 25.to_f)

        text_light_blue("#{percentage_errors}%")
      end

      def percentage_errors(total:, total_errors:)
        total_errors / total.to_f * 100
      end

      def column_errored?(column_infos:)
        return 1 if column_infos[:column_nullable] || column_infos[:column_default_value].blank?

        0
      end

      def check_enum_validity(column_infos:)
        return text_red("#{column_infos} <== ENUM IS NOT DEFINED CORRECTLY") if column_infos[:column_nullable]
        return text_red("#{column_infos} <== ENUM IS NOT DEFINED CORRECTLY") if column_infos[:column_default_value].blank?

        text_green("#{column_infos} <== ENUM IS CORRECTLY DEFINED")
      end

      def check_column_validity(column_infos:)
        return text_red("#{column_infos} <== COLUMN IS NOT DEFINED CORRECTLY") if column_infos[:column_nullable] || column_infos[:column_default_value].blank?

        text_green(column_infos)
      end

      def datas
        DatabaseReporting::Services::ReportingTables::GatheringTableColumns.new.perform
      end
    end
  end
end
