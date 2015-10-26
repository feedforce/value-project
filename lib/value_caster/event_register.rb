module ValueCaster
  class EventRegister
    def self.regist(rtm)
      new(rtm).regist
    end

    def initialize(rtm)
      @rtm = rtm
    end

    def regist
      ValueCaster::EventRouter.event_collection.each do |name, event|
        @rtm.on(name) do |data|
          event.action_class.new(data).call
        end
      end
    end
  end
end
