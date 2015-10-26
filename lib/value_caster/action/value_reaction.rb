module ValueCaster
  module Action
    class ValueReaction < Base
      def initialize
        @client = Slack::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])
      end

      def call(data)
      end
    end
  end
end
