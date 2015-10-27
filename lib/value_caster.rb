require "value_caster/version"
require 'value_caster/bot'
require 'value_caster/event'
require 'value_caster/event_router'
require 'value_caster/event_register'
require 'value_caster/action'

ValueCaster::EventRouter.draw do
  map :reaction_added, action: ValueCaster::Action::ValueReaction
end
