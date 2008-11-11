require File.dirname(__FILE__) + '/spec_helper'

describe ModelFactory, "attachments" do
  before(:all) do
    class ModelWithAttachment < ActiveRecord::Base
      has_attachment  :content_type => :image,
                      :storage => :file_system, 
                      :max_size => 1000.kilobytes, 
                      :resize_to => '384x256>', 
                      :thumbnails => { 
                          :large => '96x96>', 
                          :medium => '64x64>', 
                          :small => '48x48>'} 

      validates_as_attachment
    end
  end
  it "should satisfy validates_as_attachment" do
    create_model_with_attachment!(:uploaded_data => ModelFactory.attachment(real_path, temp_dir))
  end
end