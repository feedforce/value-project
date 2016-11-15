require "google/api_client"
require "google_drive"

# monkey patch
module Slack
  class Client
    def reactions_list(options = {})
      post('reactions.list', options)
    end
  end
end

module ValueProject
  module Action
    class ValueReaction < Base
      def initialize
        @client = Slack::Web::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])
      end

      def call(data)
        return if data.reaction != 'value'

        message = DeliveryMessage.new(data)

        post_to_slack(message)
        append_to_spread_sheet(message)
      end

      def post_to_slack(message)
        text = "#{message.reacted_username} さんが ナイス value! と言っています\n> #{message.permalink}"

        logger.info "Post message to slack `#{text}`"

        @client.chat_postMessage(
          channel: ENV['SLACK_NOTIFICATION_CHANNEL'],
          text: text,
          username: 'valueくん',
          icon_emoji: ':value:',
          unfurl_links: true
        )

        logger.info "Finish to post message to slack `#{text}`"
      end

      def append_to_spread_sheet(message)
        row = [
          message.announcer,
          message.text,
          message.permalink,
          message.reacted_username,
          message.reaction_count,
          message.timestamp,
        ]

        logger.info "Append message to Google Spread Sheet `#{row.join(',')}`"

        SpreadSheet.update_lock do
          spread_sheet = SpreadSheet.new
          spread_sheet.append(row)
          spread_sheet.save
        end

        logger.info "Finish to append message to Google Spread Sheet `#{row.join(',')}`"
      end

      class DeliveryMessage
        def initialize(data)
          @data   = data
          @client = Slack::Web::Client.new(token: ENV['SLACK_BOT_API_TOKEN'])

          reactions = @client.reactions_list(user: data.user)
          reactions = Hashie::Mash.new(reactions)

          @reacted_message = reactions.items.first.message || reactions.items.first.file
          @type = reactions.items.first.type

          logger.info "Reacted message is #{@reacted_message.to_hash}"
        end

        attr_reader :data, :reacted_message, :type

        def announcer
          reacted_message.user? ? slack_username(reacted_message.user) : reacted_message.username
        end

        def permalink
          reacted_message && reacted_message.permalink
        end

        def reaction_count
          reacted_message && reacted_message.reactions.find {|react| react.name == 'value' }['count']
        end

        def reacted_username
          @reacted_username ||= slack_username(data.user)
        end

        def text
          reacted_message && reacted_message.text
        end

        def timestamp
          Time.at(reacted_message.ts.to_i).strftime('%Y/%m/%d %H:%M:%S')
        end

        private

        def slack_username(user_id)
          user_info = @client.users_info(user: user_id)
          Hashie::Mash.new(user_info).user.name
        end

        def logger
          Logger.logger
        end
      end

      class SpreadSheet
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
                          .spreadsheet_by_key(ENV['GOOGLE_SPREAD_SHEET_ID'])
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
