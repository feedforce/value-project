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
      logger.info "User who has token #{@client.token} invites Bot(id: #{BOT_USER_ID}) in #{channel.name}"

      client.channels_join(name: channel.name)
      client.channels_invite(channel: channel.id, user: BOT_USER_ID)
      client.channels_leave(channel: channel.id)

      logger.info "User who has token #{@client.token} invited Bot(id: #{BOT_USER_ID}) in #{channel.name}"

      channel
    end

    private

    def all_channels
      Hashie::Mash.new(@client.channels_list).channels
    end

    def logger
      Logger.logger
    end
  end
end
