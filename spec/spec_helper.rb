require 'rubygems'
require 'spec'
require 'active_support'

MODELS = {
  :model => { :name => "Host" },
  :user  => {}
} unless defined?(MODELS)

require File.dirname(__FILE__) + '/../lib/model_factory.rb'