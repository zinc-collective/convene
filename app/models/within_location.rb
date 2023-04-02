module WithinLocation
  def self.included(model)
    model.extend(ClassMethods)
  end

  def location_parent
    if self.class.location_parent
      send(self.class.location_parent)
    else
      raise MissingLocationParentError, self.class
    end
  end

  delegate :routed_as, to: :class

  def parent_location(*args, **kwargs)
    location_parent.location(*args, **kwargs)
  end

  def location(action = :show, child: nil)
    root = case action
    when :new, :edit
      if routed_as == :resource
        [action] + parent_location(child: self.class.model_name.singular_route_key.to_sym)
      else
        [action] + parent_location + [self]
      end
    else
      parent_location + [self]
    end
    (root + [child]).compact
  end

  module ClassMethods
    attr_accessor :location_parent, :routed_as
    def location(on:, routed_as: :resources)
      self.location_parent = on
      self.routed_as = routed_as
    end
  end

  class MissingLocationParentError < StandardError
    def initialize(model)
      super("Missing value for `#{model}.location_parent`. Got `#{model.location_parent}`.")
    end
  end
end
