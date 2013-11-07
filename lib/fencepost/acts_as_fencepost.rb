module Fencepost
  module ActsAsFencepost
    extend ActiveSupport::Concern

    def strong_params
      @strong_params = StrongParamGenerator.new(params)
    end
  end
end

ActionController::Base.send :include, Fencepost::ActsAsFencepost
