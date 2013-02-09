libdir = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'shooting_stats/version'

Gem::Specification.new do |gem|
  gem.name        = 'shooting-stats'
  gem.version     = ShootingStats::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Conor McDermottroe"]
  gem.email       = ['conor@mcdermottroe.com']
  gem.homepage    = 'http://github.com/conormcd/shootingstats'
  gem.description = 'Calculate statistics from electronic target files.'
  gem.summary     = gem.description
  gem.license     = "BSD"

  gem.add_dependency 'sequel', '~> 3.43'
  gem.add_dependency 'sqlite3', '~> 1.3'
  gem.add_dependency 'statsample', '~> 1.2'

  gem.add_development_dependency 'cane'
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
