module ValueCaster
  class Bot
    def initialize(options = {})
      @client = Slack::Client.new(options)
      @rtm    = Slack::Client.new(options).realtime
    end

    def start
      setup
      regist
      start!
    end

    def start!
      @rtm.start
    end

    def setup
    end

    def regist
      EventRegister.regist(@rtm)
    end
  end
end
