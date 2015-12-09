module ValueProject
  class EventRegister
    def self.regist(rtm)
      new(rtm).regist
    end

    def initialize(rtm)
      @rtm = rtm
    end

    def regist
      ValueProject::EventRouter.event_collection.each do |name, event|
        @rtm.on(name) do |data|
          Logger.logger.info "Emit #{name} event, #{event.action_class} is going to call with: #{data.to_hash}."
          event.action_class.new.call(Hashie::Mash.new(data))
          Logger.logger.info "Finish #{name} event, #{event.action_class} is called with: #{data.to_hash}."
        end
      end
    end
  end
end
