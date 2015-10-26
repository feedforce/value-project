module ValueCaster
  class Bot
    def initialize(options = {})
      @client = Slack::Client.new(options)
      @rtm    = Slack::Client.new(options).realtime
    end

    def start
      setup
      @rtm.start
    end

    def setup
    end
  end
end
