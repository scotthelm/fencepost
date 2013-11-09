module Fencepost
  module ActsAsFencepost
    extend ActiveSupport::Concern
    def fencepost
      @fencepost = Fencepost.new(params)
    end
  end
end

ActionController::Base.send :include, Fencepost::ActsAsFencepost
