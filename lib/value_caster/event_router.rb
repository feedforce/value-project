module ValueCaster
  class EventRouter
    def self.event_collection
      @event_collection ||= {}
    end

    def self.draw(&block)
      new.instance_eval(&block)
    end

    def map(event_name, action:, method: nil)
      add Event.new(event_name, action: action, method: method)
    end

    private

    def add(event)
      self.class.event_collection[event.name.to_sym] = event
    end
  end
end
