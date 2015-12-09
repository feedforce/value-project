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
          begin
            logger.info "Emit #{name} event, #{event.action_class} is going to call with: #{data.to_hash}."
            event.action_class.new.call(Hashie::Mash.new(data))
            logger.info "Finish #{name} event, #{event.action_class} is called with: #{data.to_hash}."
          rescue
            logger.error "Failed to #{name} action with #{data}.\nbacktrace: #{$!.backtrace.join("\n")}"
          end
        end
      end
    end

    private

    def logger
      Logger.logger
    end
  end
end
