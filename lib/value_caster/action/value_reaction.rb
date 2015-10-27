module ValueCaster
  module Action
    class ValueReaction < Base
      def initialize
        @client = Slack::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])
      end

      def call(data)
        return if data.reaction != 'value'

        post_to_slack(data)
      end

      def post_to_slack(data)
        user_id = data.user

        reacted_username = slack_username(user_id)
        reacted_message  = reacted_message(user_id)

        text = "#{reacted_username} さんが ナイス value! と言っています\n> #{reacted_message.permalink}"

        @client.chat_postMessage(
          channel: ENV['SLACK_NOTIFICATION_CHANNEL'],
          text: text,
          username: 'valueくん',
          icon_emoji: ':value:',
          unfurl_links: true
        )
      end

      def reacted_message(user_id)
        reactions = @client.reactions_list(user: user_id)
        reactions = Hashie::Mash.new(reactions)
        SlackMessage.new(reactions.items.first.message)
      end

      def slack_username(user_id)
        user_info = @client.users_info(user: user_id)
        Hashie::Mash.new(user_info).user.name
      end

      class SlackMessage < Hashie::Mash
      end
    end
  end
end
