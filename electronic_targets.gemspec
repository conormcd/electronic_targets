require File.expand_path('../lib/electronic_targets/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'electronic_targets'
  gem.version     = ElectronicTargets::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Conor McDermottroe"]
  gem.email       = ['conor@mcdermottroe.com']
  gem.homepage    = 'http://github.com/conormcd/electronic_targets'
  gem.description = 'Extract data from electronic target files.'
  gem.summary     = gem.description
  gem.license     = "BSD"

  gem.add_dependency 'ruby-ole'
  gem.add_dependency 'sequel', '~> 3.43'
  gem.add_dependency 'sqlite3', '~> 1.3'

  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'json', '~> 1.7'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- spec/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{
                         |f| File.basename(f)
                       }
  gem.require_paths = ['lib']
end
