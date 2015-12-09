module ValueProject
  module Action
    class BotInvitation < Base
      def call(data)
        ValueProject::SlackChannel.new.leave_bot(data.channel)
      end
    end
  end
end
