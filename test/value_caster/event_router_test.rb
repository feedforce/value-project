require './test/test_helper'
require './lib/value_caster/event_router'
require './lib/value_caster/event'

describe ValueCaster::EventRouter do
  describe 'draw' do
    it 'event collection has event names in hash after ValueCaster::EventRouter#draw' do
      ValueCaster::EventRouter.draw do
        map :event1, action: :action1
        map :event2, action: :action2
      end

      assert {
        ValueCaster::EventRouter.event_collection.keys == [ :event1, :event2 ]
      }
    end

    it 'Event has currect attributes after ValueCaster::EventRouter#draw' do
      ValueCaster::EventRouter.draw do
        map :event, action: :action
      end

      event = ValueCaster::EventRouter.event_collection[:event]

      assert { event.name   == :event }
      assert { event.action == :action }
      assert { event.method == :call }
    end

    it 'if EventRouter#map does not specify `action`, raises error' do
      begin
        ValueCaster::EventRouter.draw do
          map :event
        end
      rescue => e
        assert { ArgumentError === e }
      end
    end
  end
end
