module ValueCaster
  class Bot
    def initialize(options = {})
      @rtm = Slack::Client.new(options).realtime
    end

    def run
      setup
      regist
      start
    end

    def start
      @rtm.start
    end

    def setup
    end

    def regist
      EventRegister.regist(@rtm)
    end
  end
end
