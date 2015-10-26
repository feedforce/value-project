module ValueCaster
  class Event
    def initialize(event_name, action:, method: nil)
      @name   = event_name
      @action = action
      @method = method || :call
    end

    attr_reader :name, :action, :method
  end
end
