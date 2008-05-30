require File.dirname(__FILE__) + '/spec_helper'

describe "ModelFactory" do
  
  def create_method(class_name,attributeshash={})
    meth = method("create_#{class_name.tableize.singularize}".to_sym)
    meth.call(attributeshash)
  end
  
  for model in %w( Model User )
    
    before(:each) do
      class_definition = <<-END
        class #{model}
          def self.create(h={}) 
            new
          end
        end
      END
      eval class_definition
      @klazz = eval(model)
    end
  
    it "should create a model" do
      @klazz.should_receive(:create)
      create_method(model)
    end
  
    it "should return an instance of the new model" do
      create_method(model).should be_kind_of(@klazz)
    end
  
    it "should apply given parameterhash as attributes to create" do
      @klazz.should_receive(:create).with(:attribute => "value")
      create_method(model, :attribute => 'value')
    end
  
  end
  
end

