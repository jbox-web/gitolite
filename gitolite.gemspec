# frozen_string_literal: true

require_relative 'lib/gitolite/version'

Gem::Specification.new do |s|
  s.name        = 'jbox-gitolite'
  s.version     = Gitolite::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/gitolite'
  s.summary     = %q(A Ruby gem for manipulating the Gitolite Git backend via the gitolite-admin repository.)
  s.description = %q(This gem is designed to provide a Ruby interface to the Gitolite Git backend system. This gem aims to provide all management functionality that is available via the gitolite-admin repository (like SSH keys, repository permissions, etc))
  s.license     = 'MIT'

  s.rubyforge_project = 'jbox-gitolite'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'gitlab-grit', '~> 2.7', '>= 2.7.2'
  s.add_runtime_dependency 'gratr19', '~> 0.4', '>= 0.4.4.1'

  s.add_development_dependency 'forgery'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end
