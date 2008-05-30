class ModelFactory
  class << self
    def create(class_name_sym, attributeshash={})
      klazz = eval("#{class_name_sym.to_s.camelize.singularize}")
      attrs = MODELS[class_name_sym].merge(attributeshash)
      bt_assocs = attrs.select {|k,v| (k.to_s =~ /.*_id$/) && (v != nil) }.map {|k,v| [k.to_s.sub(/_id/, '').camelize, v]}
      begin
        bt_assocs.each do |k,v|
          klass = eval(k)
          klass.find(v)
        end
      rescue ActiveRecord::RecordNotFound => e
        e.to_s =~ /find\s+(.*)\s+with/
        klass = $1.tableize.singularize.to_sym
        create(klass)
      end
      record = klazz.new(attrs)
      record.save
      record
    end
  end
end

MODELS.each do |name, pre_def_attributeshash|
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

