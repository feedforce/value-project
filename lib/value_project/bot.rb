module ValueProject
  class Bot
    def initialize
      @rtm = Slack::Client.new(token: ENV['SLACK_BOT_API_TOKEN']).realtime
    end

    def self.run
      new.run
    end

    def run
      setup
      regist
      start
    end

    def start
      logger.info 'Run Slack realtime client start...'
      @rtm.start
    end

    def setup
      SlackChannel.invite_all
    end

    def regist
      EventRegister.regist(@rtm)
    end

    private

    def logger
      Logger.logger
    end
  end
end
