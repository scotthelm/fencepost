require "fencepost/fencepost"
require "fencepost/gate"
require "fencepost/acts_as_fencepost"
require "fencepost/configuration"
require "fencepost/railtie"

module Fencepost
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
