# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.push(lib) unless $LOAD_PATH.include?(lib)
require 'gitolite/version'

Gem::Specification.new do |s|
  s.name        = 'jbox-gitolite'
  s.version     = Gitolite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nrodriguez@jbox-web.com']
  s.homepage    = 'https://github.com/jbox-web/gitolite'
  s.summary     = %q{A Ruby gem for manipulating the Gitolite Git backend via the gitolite-admin repository.}
  s.description = %q{This gem is designed to provide a Ruby interface to the Gitolite Git backend system. This gem aims to provide all management functionality that is available via the gitolite-admin repository (like SSH keys, repository permissions, etc)}
  s.license     = 'MIT'

  s.rubyforge_project = 'jbox-gitolite'

  s.add_runtime_dependency 'gitlab-grit', '~> 2.7', '>= 2.7.2'
  s.add_runtime_dependency 'gratr19', '~> 0.4', '>= 0.4.4.1'

  s.add_development_dependency 'rake',      '~> 10.3', '>= 10.3.1'
  s.add_development_dependency 'rdoc',      '~> 4.1',  '>= 4.1.1'
  s.add_development_dependency 'rspec',     '~> 3.1',  '>= 3.1.0'
  s.add_development_dependency 'forgery',   '~> 0.6',  '>= 0.6.0'
  s.add_development_dependency 'simplecov', '~> 0.9',  '>= 0.9.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
