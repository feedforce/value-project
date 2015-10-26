module ValueCaster
  class Bot
    def initialize(options = {})
      @client = Slack::Client.new(options)
      @rtm    = Slack::Client.new(options).realtime
    end

    def start
      @rtm.start
    end
  end
end
