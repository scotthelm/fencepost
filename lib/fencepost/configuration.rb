module Fencepost
  class Configuration
    attr_accessor :dev_mode

    def initialize
      @dev_mode = false
    end
  end
end
