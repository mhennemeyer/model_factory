if defined?(MODEL_FACTORY_MODELS)
  class ModelFactory
    class << self
      
      def attachment(path_to_existing_file)
        tempfile = ActionController::UploadedTempfile.new("dumb")
        tempfile.puts File.open(path_to_existing_file, "r").readlines
        tempfile.content_type = "image/png"
        tempfile.original_path = path_to_existing_file
        tempfile.close
        tempfile.open
        tempfile
      end
      
      def create(class_name_sym, attributeshash={})
        klazz_name = class_name_sym.to_s.camelize.singularize
        klazz = klazz_name.constantize
        attrs = MODEL_FACTORY_MODELS[class_name_sym].merge(attributeshash)
        if (path = attrs[:uploaded_data])
          raise "#{klazz_name} seems not to be attachable" unless klazz.respond_to?(:attachment_options)
          klazz.attachment_options[:path_prefix] = "/public/attachment_models"
          attrs[:uploaded_data] = attachment(path)
        end
        bt_assocs = attrs.select {|k,v| (k.to_s =~ /.*_id$/) && (v != nil) }.map {|k,v| [k.to_s.sub(/_id/, '').camelize, v]}
        bt_assocs.each do |k,v|
          begin
            klass = eval(k)
            klass.find(v)
          rescue ActiveRecord::RecordNotFound => e
            e.to_s =~ /find\s+(.*)\s+with/
            klass = $1.tableize.singularize.to_sym
            create(klass)
          end
        end
        record = klazz.new(attrs)
        record.save
        record
      end
    end
  end

  MODEL_FACTORY_MODELS.each do |name, pre_def_attributeshash|
    eval <<-END
      def create_#{name}(attributeshash={})
        ModelFactory.create(:#{name}, attributeshash)
      end
      def create_#{name}!(attributeshash={})
        record = ModelFactory.create(:#{name}, attributeshash)
        record.save!
        record
      end
    END
  end
end

