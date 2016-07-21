require 'rubygems'
require 'simplecov'
require 'forgery'

require 'codeclimate-test-reporter'

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
])

SimpleCov.start

require 'gitolite'

def config_files_dir
  File.join(File.dirname(__FILE__), 'fixtures', 'configs')
end


def ssh_key_files_dir
  File.join(File.dirname(__FILE__), 'fixtures', 'keys')
end
