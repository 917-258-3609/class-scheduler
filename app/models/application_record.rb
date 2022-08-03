class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  protected
  # has_toggled_attr(x) builds functions for attr 'is_x' 
  def self.has_toggled_attr(attr_name)
    define_singleton_method("#{attr_name}") do
      where("is_#{attr_name}": true)
    end
    define_singleton_method("not_#{attr_name}".to_sym) do
      where("is_#{attr_name}": false)
    end
    send(:define_method, "make_#{attr_name}") do
      self.send("update", "is_#{attr_name}": true)
      self.send("save!")
    end
    send(:define_method, "make_not_#{attr_name}") do
      self.send("update", "is_#{attr_name}": false)
      self.send("save!")
    end
    send(:define_method, "toggle_#{attr_name}") do
      self.send("is_#{attr_name}=", !self.send("is_#{attr_name}"))
      self.send("save!")
    end
    send(:define_method, "is_#{attr_name}?") do
      self.send("is_#{attr_name}")
    end
  end
end
