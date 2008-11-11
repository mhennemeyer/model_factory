require File.dirname(__FILE__) + '/spec_helper'

describe ModelFactory, "attachments" do
  before(:all) do
    AttachmentModel.destroy_all if defined?(AttachmentModel)
    require File.dirname(__FILE__) + '/rails_root/spec/spec_helper'
    class AttachmentModel < ActiveRecord::Base
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
    unless AttachmentModel.table_exists?
      ActiveRecord::Migration.create_table :attachment_models do |t|
        t.integer :parent_id
        t.integer :size
        t.integer :width
        t.integer :height
        t.string :content_type
        t.string :filename
        t.string :thumbnail
        t.timestamps
      end
    end 
  end
  
  def path_to_existing_image
    File.dirname(__FILE__) + '/tmp/test_image.png'
  end
  
  it "should satisfy validates_as_attachment" do
    create_attachment_model!(:uploaded_data => path_to_existing_image)
  end
  
  describe "generates thumbnails" do
    
    before(:all) do
      create_attachment_model!(:uploaded_data => path_to_existing_image)
      @thumbnails = AttachmentModel.all.select(&:thumbnail)
    end
    
    it "should generate three thumbnails" do
      @thumbnails.size.should eql(3)
    end
    
    it "should generate small, medium and large thumbnails" do
      %w(small medium large).each do |size|
        (thumbnail = @thumbnails.detect {|t| t.thumbnail == size}).should_not be_nil
      end
    end
  end
end