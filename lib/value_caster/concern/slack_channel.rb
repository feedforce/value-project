module ValueCaster
  class SlackChannel
    BOT_USER_ID = 'U0BFF4VB7'

    def initialize
      @client = Slack::Client.new(token: ENV['SLACK_USER_API_TOKEN'])
    end

    attr_reader :client

    def self.invite_all
      new.invite_all
    end

    def invite_all
      all_channels.each do |channel|
        next if channel.members.include?(BOT_USER_ID)

        result = client.channels_invite(channel: channel.id, user: BOT_USER_ID)

        unless result['ok']
          leave_bot(channel)
        end
      end
    end

    def leave_bot(channel)
      client.channels_join(name: channel.name)
      client.channels_invite(channel: channel.id, user: BOT_USER_ID)
      client.channels_leave(channel: channel.id)
    end

    private

    def all_channels
      Hashie::Mash.new(@client.channels_list).channels
    end
  end
end
