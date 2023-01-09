module DatabaseReporting
  module Services
    module DatabaseSizing
      class DatabaseSizeService
        attr_reader :database_name, :adapter
        def initialize
          @database_name = ActiveRecord::Base.connection.instance_variable_get("@config")[:database]
          @adapter = ActiveRecord::Base.connection.adapter_name.downcase
        rescue StandardError => e
          nil
        end

        def perform
          case adapter
          when "mysql"
            sql = "select FORMAT(SUM(data_length + index_length), 0) as bytes from information_schema.TABLES where table_schema = '#{database_name}'"
            puts ActiveRecord::Base.connection.execute(sql).fetch_hash.values.first
          when "postgres", "postgresql"
            sql = "SELECT pg_size_pretty(pg_database_size('#{database_name}'));"
            count = ActiveRecord::Base.connection.execute(sql)[0]["pg_size_pretty"]
            puts count
            return count
          when "oracle", "oci"
            sql = "select a.data_size+b.temp_size+c.redo_size+d.controlfile_size  from ( select sum(bytes) data_size from dba_data_files) a, ( select nvl(sum(bytes),0) temp_size from dba_temp_files ) b, ( select sum(bytes) redo_size from sys.v_$log ) c, ( select sum(BLOCK_SIZE*FILE_SIZE_BLKS) controlfile_size from v$controlfile) d;"
            count = ActiveRecord::Base.connection.execute(sql).fetch_hash.values.first
            puts count
            return count
          when 'sqlite'
            sql1 = "pragma page_size"
            sql2 = "pragma page_count"
            size = ActiveRecord::Base.connection.execute(sql1)&.first&.dig("page_size")&.to_i
            count = ActiveRecord::Base.connection.execute(sql2)&.first&.dig("page_count")&.to_i
            puts "#{size} * #{count} = #{size * count}"
            return size * count
          else
            puts "Adapter #{adapter} not supported"
            return 0
          end
        end
      end
    end
  end
end
