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

  def parent_location
    location_parent.location
  end

  def location(action = :show, child: nil)
    root = case action
    when :new
      ([:new] + parent_location + [self])
    when :edit
      [:edit] + parent_location + [self]
    else
      parent_location + [self]
    end

    (root + [child]).compact
  end

  module ClassMethods
    attr_accessor :location_parent
  end

  class MissingLocationParentError < StandardError
    def initialize(model)
      super("Missing value for `#{model}.location_parent`. Got `#{model.location_parent}`.")
    end
  end
end
