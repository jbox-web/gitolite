require 'simplecov'
require 'forgery'
require 'rspec'

# Start Simplecov
SimpleCov.start do
  add_filter 'spec/'
end

# Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!
end

# Load lib
require 'gitolite'

FIXTURE_PATH      = File.expand_path File.join(File.dirname(__FILE__), 'fixtures')
CONFIG_FILES_DIR  = File.join(FIXTURE_PATH, 'configs')
SSH_KEY_FILES_DIR = File.join(FIXTURE_PATH, 'keys')
OUTPUT_DIR        = '/tmp'
