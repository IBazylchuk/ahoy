module Ahoy
  class BaseController < ActionController::Base
    # skip all filters except for authlogic
    skip_filter *(_process_action_callbacks.map(&:filter) - [:load_authlogic])

    def ahoy
      @ahoy ||= Ahoy::Tracker.new(controller: self, api: true)
    end
  end
end
