require File.dirname(__FILE__) + '/spec_helper'

describe "ModelFactory" do
  
  def get_and_call_create_method(class_name,attributeshash={})
    meth = method("create_#{class_name.tableize.singularize}".to_sym)
    meth.call(attributeshash)
  end
  
  before(:each) do
    MODELS.each do |name, hash|
      model = name.to_s.camelize.singularize
      eval <<-END
        class #{model}
          def initialize(h={}) 
          end
          def save
          end
        end
      END
    end
  end
  
  MODELS.each do |name, hash|
    model = name.to_s.camelize.singularize
    describe "create_#{model.downcase}" do
      
      before(:each) do
        @klazz = eval(model)
        @obj   = @klazz.new
      end
  
      it "should construct a new #{model.downcase}" do
        @klazz.should_receive(:new).and_return(@obj)
        get_and_call_create_method(model)
      end
  
      it "should return an instance of the new #{model.downcase}" do
        get_and_call_create_method(model).should be_kind_of(@klazz)
      end
    
      it "should apply MODELS[model] as attributes to create" do
        @klazz.should_receive(:new).with(hash).and_return(@obj)
        get_and_call_create_method(model)
      end
      
      it "should merge parameters to applied arguments for create" do
        @klazz.should_receive(:new).with(hash.merge(:attribute => "value")).and_return(@obj)
        get_and_call_create_method(model, :attribute => 'value')
      end
      
      it "should save the new record" do
        @obj.should_receive(:save)
        @klazz.should_receive(:new).and_return(@obj)
        get_and_call_create_method(model)
      end
    end
    describe "create_#{model.downcase}!" do
      
      before(:each) do
        @klazz = eval(model)
        @obj   = @klazz.new
      end
      
      it "should call create_#{model.downcase} and call save! on the returned #{model.downcase} object" do
        @obj.should_receive(:save!)
        @klazz.should_receive(:new).and_return(@obj)
        method("create_#{model.tableize.singularize}!".to_sym).call
      end
    end
  end
  
  it "should try to find bt-associated models ( *_id)" do
    User.should_receive(:find).with(1)
    create_model :user_id => 1    
  end
  
  it "should build the association if not found" do
    module ActiveRecord
      class RecordNotFound < StandardError;end
    end
    obj = User.new
    User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound.new "Couldn't find User with id 1")
    User.should_receive(:new).and_return(obj)
    create_model :user_id => 1
  end
  
end

