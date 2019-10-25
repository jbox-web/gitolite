# frozen_string_literal: true

require 'grit'
require 'gratr'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'ssh_key' => 'SSHKey'
loader.setup

module Gitolite
end
