# Exposes a method that builds an array which represents a Resource's position in relation to other
# Resources in our object graph for use in url and path construction. The `location` method is
# specifically designed for use with custom helpers that operate like `polymorphic_url` and
# `polymorphic_path` helpers that receive models as arguments. By enabling consistent view code
# for polymorphic helpers, we support navigating between both branded an unbranded domain Spaces
# seamlessly.
#
# Usage:
# ```
# # Within a record model you can define a parent explicitly:
# self.location_parent = :[PARENT_NAME]
#
# # Record models can declare the `location` array as a class method to expose it to other class
# methods:
# ```
# class Furniture < ApplicationRecord
#   location(parent: :[PARENT_NAME])
#   ...
# end
# ```
#
# # You can send the `location` message to Records from objects or views:
# ```
# <%= button_to("checkout", cart.location(child: :checkout), data: { turbo: false }) %>
# ```
# Without this method, you'd have to do:
# ```
# <%= button_to("checkout", [space, room, marketplace, :checkout], data: { turbo: false }) %>
# ```
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

  def parent_location(*, **)
    location_parent.location(*, **)
  end

  def location(action = :show, child: nil, query_params: nil)
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

    (root + [child, query_params]).compact
  end

  module ClassMethods
    attr_accessor :location_parent, :routed_as

    def location(parent:, routed_as: :resources)
      @location_parent = parent
      @routed_as = routed_as
    end
  end

  class MissingLocationParentError < StandardError
    def initialize(model)
      super("Missing value for `#{model}.location_parent`. Got `#{model.location_parent}`.")
    end
  end
end
