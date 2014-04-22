require 'rubygems'
require 'spork'
require 'forgery'
require 'logger'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

LOG = Logger.new('test.log')

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.
  require File.expand_path('../../lib/gitolite', __FILE__)
  include Gitolite
end
