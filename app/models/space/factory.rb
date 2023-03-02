# frozen_string_literal: true

class Space::Factory
  def self.create(space_attributes)
    blueprint_name = space_attributes.delete(:blueprint)
    space = Space.create_with(space_attributes)
      .find_or_create_by(name: space_attributes[:name])

    if blueprint_name.present?
      Blueprint.new(
        Blueprint::BLUEPRINTS[blueprint_name],
        space: space
      ).find_or_create!
    end

    space
  end
end
