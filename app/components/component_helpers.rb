module ComponentHelpers
  # Finds components by name and instantiates them to prepare for a render call
  def component(name, *args, **kwargs, &block)
    Object.const_get("#{name.to_s.titleize}Component").new(*args, **kwargs, &block)
  end

  def self.included(klass)
    klass.helper_method(:component) if klass.respond_to?(:helper_method)
  end
end
