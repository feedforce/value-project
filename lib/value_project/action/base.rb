module ValueProject
  module Action
    class Base
      def call(data)
        raise NotImplementedError
      end

      private

      def logger
        Logger.logger
      end
    end
  end
end
