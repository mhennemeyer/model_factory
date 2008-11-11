require 'rubygems'
require 'spec'
require 'active_support'

MODEL_FACTORY_MODELS = {
  :model => { :name => "Horst" },
  :user  => {},
  :attachment_model => {}
} unless defined?(MODEL_FACTORY_MODELS)

require File.dirname(__FILE__) + '/../lib/model_factory.rb'