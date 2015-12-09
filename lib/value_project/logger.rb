module ValueCaster
  class Logger
    class << self
      def logger
        @logger ||= begin
          $stdout.sync = true
          ::Logger.new($stdout)
        end
      end
    end
  end
end
