require 'rubygems'
require 'simplecov'
require 'forgery'
require 'rspec'
require 'support/helper'

## Start Simplecov
SimpleCov.start do
  add_filter 'spec/'
end

## Configure RSpec
RSpec.configure do |config|
  include Helper

  config.color = true
  config.fail_fast = false
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'gitolite'
