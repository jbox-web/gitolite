require 'rubygems'
require 'forgery'

require 'simplecov'
require 'simplecov-rcov'
require 'coveralls'
require 'codeclimate-test-reporter'

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  Coveralls::SimpleCov::Formatter,
  CodeClimate::TestReporter::Formatter
]

SimpleCov.start

require_relative '../lib/gitolite'
include Gitolite


def config_files_dir
  File.join(File.dirname(__FILE__), 'fixtures', 'configs')
end


def ssh_key_files_dir
  File.join(File.dirname(__FILE__), 'fixtures', 'keys')
end
