require 'rubygems'
require 'forgery'

require 'simplecov'
require 'simplecov-rcov'

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
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
