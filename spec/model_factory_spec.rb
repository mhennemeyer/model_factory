require File.dirname(__FILE__) + '/spec_helper'

describe "ModelFactory" do
  
  before(:each) do
    class Model
      def self.create(h={})
        new
      end
    end
  end
  
  it "should create a model" do
    Model.should_receive(:create)
    create_model
  end
  
  it "should return an instance of the new model" do
    create_model.should be_kind_of(Model)
  end
  
  it "should apply given parameterhash as attributes to create" do
    Model.should_receive(:create).with(:attribute => "value")
    create_model :attribute => "value"
  end
  
end