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
require "value_caster/logger"
require 'redis/objects'
require 'redis/lock'

Redis.current = Redis.new(url: ENV["REDISTOGO_URL"] || 'redis://localhost:6379/0')

ValueCaster::EventRouter.draw do
  map :reaction_added,  action: :value_reaction
  map :channel_created, action: :bot_invitation
end
