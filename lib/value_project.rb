require 'hashie/mash'
require 'active_support'
require 'active_support/core_ext'
require 'celluloid/current'
require 'celluloid/io'
require 'slack'
require "value_project/version"
require 'value_project/concern/slack_channel'
require 'value_project/bot'
require 'value_project/event'
require 'value_project/event_router'
require 'value_project/event_register'
require 'value_project/action'
require "value_project/logger"
require 'redis/objects'
require 'redis/lock'

Redis.current = Redis.new(url: ENV["REDISTOGO_URL"] || 'redis://localhost:6379/0')

ValueProject::EventRouter.draw do
  map :reaction_added,  action: :value_reaction
  map :channel_created, action: :bot_invitation
end
