module DatabaseReporting
  module Services
    module DatabaseSizing
      class TableSizeService
        attr_reader :database_name, :adapter
        def initialize(table:)
          @table = table
          @database_name = ActiveRecord::Base.connection.instance_variable_get("@config")[:database]
          @adapter = ActiveRecord::Base.connection.adapter_name.downcase
        rescue StandardError => e
          nil
        end

        def perform
          case adapter
          when "mysql"
            sql = "select TABLE_NAME, FORMAT((data_length + index_length), 0) as bytes from information_schema.TABLES where table_schema = '#{database_name}' AND table_name = '#{table}' ORDER BY (data_length + index_length) DESC"
            res = ActiveRecord::Base.connection.execute(sql)
            count = res[0]['bytes']
            puts count
            return count
          when "postgres", "postgresql"
            sql = "SELECT pg_size_pretty(pg_total_relation_size('#{table}'));"
            res = ActiveRecord::Base.connection.execute(sql)
            count = res[0]['pg_size_pretty']
            puts count
            return count
          when 'sqlite'
            sql1 = "pragma page_size"
            count = ActiveRecord::Base.connection.execute(sql1)&.first&.dig("page_size")&.to_i
            return count
          else
            puts "Adapter #{adapter} not supported"
            return 0
          end
        end
      end
    end
  end
end
