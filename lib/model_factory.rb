for model in MODELS
  class_name = 
end

def create_user(attributeshash={})
  User.create attributeshash
end

def create_model(attributeshash={})
  Model.create attributeshash
end

def create_method(class_name,attributeshash={})
  meth = method("create_#{class_name.tableize.singularize}".to_sym)
  meth.call(attributeshash)
end