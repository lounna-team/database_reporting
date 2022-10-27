# frozen_string_literal: true

desc 'Database reporting'
namespace :database_reporting do
  desc 'Get database sizing from everything'
  task database_sizing: :environment do
    tables = ActiveRecord::Base.connection.tables

    puts "TABLE_NAME\n  NB_OF_LINES\n  PLACEHODLER\n  PLACEHODLER"

    tables.each do |table|
      next if table.match(/\Aschema_migrations\Z/) || table.match(/\Aar_internal_metadata\Z/)

      sql = "select count(*) as nb_lines from #{table}"
      res = ActiveRecord::Base.connection.execute(sql)
      number_of_lines = res[0]['nb_lines']
      puts "#{table.classify}\n  #{number_of_lines}\n  PLACEHOLDER\n  PLACEHOLDER"
    end
  end
end
