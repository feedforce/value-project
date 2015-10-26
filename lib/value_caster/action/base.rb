module ValueCaster
  module Action
    class Base
      def call(data)
        raise NotImplementedError
      end
    end
  end
end
