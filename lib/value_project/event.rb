module ValueCaster
  class Event
    def initialize(event_name, action:, method: nil)
      @name   = event_name
      @action = action
      @method = method || :call
    end

    attr_reader :name, :action, :method

    def action_class
      "ValueCaster::Action::#{action.to_s.classify}".constantize
    end
  end
end
