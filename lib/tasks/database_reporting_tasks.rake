desc "Table last update / entry"
namespace :database_reporting do
  task database_sizing: :environment do
    tables = ActiveRecord::Base.connection.tables
    puts "TABLE NAME || LAST ENTRY"
    tables.each do |table|
      next if table.match(/\Aschema_migrations\Z/)
      next if table.match(/\Aar_internal_metadata\Z/)
      klass = table.singularize.camelize.constantize
      
      puts "#{klass.name} has #{klass.order(updated_at: :desc).first.updated_at} "
    end
  end
end
