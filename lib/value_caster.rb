require 'hashie/mash'
require 'active_support'
require 'active_support/core_ext'
require 'slack'
require "value_caster/version"
require 'value_caster/concern/slack_channel'
require 'value_caster/bot'
require 'value_caster/event'
require 'value_caster/event_router'
require 'value_caster/event_register'
require 'value_caster/action'

ValueCaster::EventRouter.draw do
  map :reaction_added, action: :value_reaction
end
