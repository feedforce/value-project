require './test/test_helper'
require './lib/value_project/event_router'
require './lib/value_project/event'

describe ValueProject::EventRouter do
  describe 'draw' do
    before do
      ValueProject::EventRouter.event_collection.clear
    end

    after do
      ValueProject::EventRouter.event_collection.clear
    end

    it 'event collection has event names in hash after ValueProject::EventRouter#draw' do
      ValueProject::EventRouter.draw do
        map :event1, action: :action1
        map :event2, action: :action2
      end

      assert {
        ValueProject::EventRouter.event_collection.keys == [ :event1, :event2 ]
      }
    end

    it 'Event has currect attributes after ValueProject::EventRouter#draw' do
      ValueProject::EventRouter.draw do
        map :event, action: :action
      end

      event = ValueProject::EventRouter.event_collection[:event]

      assert { event.name   == :event }
      assert { event.action == :action }
      assert { event.method == :call }
    end

    it 'if EventRouter#map does not specify `action`, raises error' do
      begin
        ValueProject::EventRouter.draw do
          map :event
        end
      rescue => e
        assert { ArgumentError === e }
      end
    end
  end
end
