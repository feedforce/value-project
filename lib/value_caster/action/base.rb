module ValueCaster
  module Action
    class Base
      def initialize(data)
        @data = data
      end

      attr_accessor :data

      def call
        raise NotImplementedError
      end
    end
  end
end
