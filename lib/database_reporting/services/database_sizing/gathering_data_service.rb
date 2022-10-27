module DatabaseReporting
  module Services
    module DatabaseSizing
      class GatheringDataService
        def initialize(database_name:)
          @database_name = database_name
        rescue StandardError => e
          nil
        end

        def perform
          #pragma page_size;
          #ActiveRecord::Base.connection.tables.each do |name|
            #next if table.match(/\Aschema_migrations\Z/)
           # puts ActiveRecord::Base.connection.table_struc(name)
            #klass = table.singularize.camelize.constantize      
            #puts "#{klass.name} has #{klass.count} records"

          database_name = ActiveRecord::Base.connection.instance_variable_get("@config")[:database]
          adapter = ActiveRecord::Base.connection.adapter_name.downcase
          case adapter
          when "mysql"
            sql = "select FORMAT(SUM(data_length + index_length), 0) as bytes from information_schema.TABLES where table_schema = '#{database_name}'"
            puts ActiveRecord::Base.connection.execute(sql).fetch_hash.values.first
          when "postgres", "postgresql"
            sql = "SELECT pg_size_pretty(pg_database_size('#{database_name}'));"
            puts ActiveRecord::Base.connection.execute(sql)[0]["pg_size_pretty"]
          when "oracle", "oci"
            sql = "select a.data_size+b.temp_size+c.redo_size+d.controlfile_size  from ( select sum(bytes) data_size from dba_data_files) a, ( select nvl(sum(bytes),0) temp_size from dba_temp_files ) b, ( select sum(bytes) redo_size from sys.v_$log ) c, ( select sum(BLOCK_SIZE*FILE_SIZE_BLKS) controlfile_size from v$controlfile) d;"
            puts ActiveRecord::Base.connection.execute(sql).fetch_hash.values.first
          when 'sqlite'
            sql1 = "pragma page_size"
            sql2 = "pragma page_count"
            size = ActiveRecord::Base.connection.execute(sql1)&.first&.dig("page_size")&.to_i
            count = ActiveRecord::Base.connection.execute(sql2)&.first&.dig("page_count")&.to_i
            puts "#{size} * #{count} = #{size * count}"
          else
            puts adapter
          end
        end
      end
    end
  end
end
