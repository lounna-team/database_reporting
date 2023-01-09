require_relative 'lib/database_reporting/version'

Gem::Specification.new do |spec|
  spec.name        = 'database_reporting'
  spec.version     = DatabaseReporting::VERSION
  spec.authors     = ['Mayacine Diop']
  spec.email       = ['diopmayacine86@gmail.com']
  spec.homepage    = 'https://www.hoggo.com'
  spec.summary     = 'Summary of DatabaseReporting.'
  spec.description = 'Reporting informations of the database'
    spec.license     = 'MIT'
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'www.hoggo.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://www.hoggo.com'
  spec.metadata['changelog_uri'] = 'https://www.hoggo.com'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 6.1'
end
