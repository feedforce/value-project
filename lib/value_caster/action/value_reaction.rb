require "google/api_client"
require "google_drive"
require 'redis/objects'
require 'redis/lock'

module ValueCaster
  module Action
    class ValueReaction < Base
      def initialize
        @client = Slack::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])
      end

      def call(data)
        return if data.reaction != 'value'

        post_to_slack(data)
        append_to_spread_sheet(data)
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

      def append_to_spread_sheet(data)
        user_id = data.user

        reacted_username = slack_username(user_id)
        reacted_message  = reacted_message(user_id)

        row = [
          reacted_message.username,
          reacted_message.text,
          reacted_message.permalink,
          reacted_username,
          reacted_message.count,
          reacted_message.timestamp,
        ]

        SpreadSheet.update_lock do
          spread_sheet = SpreadSheet.new
          spread_sheet.append(row)
          spread_sheet.save
        end
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

      class DeliveryMessage
        def initialize(data)
          @data   = data
          @client = Slack::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])
        end

        attr_reader :data

        def reacted_username
          slack_username(data.user)
        end

        def reacted_message
          reactions = @client.reactions_list(user: data.user)
          reactions = Hashie::Mash.new(reactions)
          reactions.items.first.message
        end

        def slack_username(user_id)
          user_info = @client.users_info(user: user_id)
          Hashie::Mash.new(user_info).user.name
        end

        def count
          # TODO
        end

        def timestamp
          # TODO
        end
      end

      class SlackMessage < ::Hashie::Mash
        def count
          reactions.find {|react| react.name == 'value' }.count
        end

        def timestamp
          Time.at(ts.to_i).strftime('%Y/%m/%d %H:%M:%S')
        end
      end

      class SpreadSheet
        SHEET_ID = '18DwKbuMfj22H9XWm-HigilxZHtFa_n8F0fwB_K-fNnE'

        def initialize
          signet = Signet::OAuth2::Client.new(
            client_id: ENV['GOOGLE_CLIENT_ID'],
            client_secret: ENV['GOOGLE_CLIENT_SECRET'],
            authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
            scope: [ "https://www.googleapis.com/auth/drive" ],
            refresh_token: ENV['GOOGLE_REFRESH_TOKEN']
          )

          signet.refresh!
          @work_sheet = GoogleDrive.login_with_oauth(signet.access_token)
                          .spreadsheet_by_key(SHEET_ID)
                          .worksheets[0]
        end

        attr_reader :work_sheet

        def self.update_lock(&block)
          Redis::Lock.new('google-drive-update', timeout: 10).lock do
            yield
          end
        end

        def append(data)
          data.each.with_index(1) do |d, i|
            @work_sheet[max_row_size + 1, i] = d
          end
        end

        def save
          @work_sheet.save
        end

        private

        def max_row_size
          @max_row_size ||= @work_sheet.rows.size
        end
      end
    end
  end
end
