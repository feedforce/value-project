module ValueCaster
  module Action
    class BotInvitation < Base
      def call(data)
        ValueCaster::SlackChannel.new.leave_bot(data.channel)
      end
    end
  end
end
