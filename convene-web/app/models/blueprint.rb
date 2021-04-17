# Assembles Spaces idempotently
class Blueprint
  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def find_or_create!
    space = client.spaces.find_or_initialize_by(name: space_attributes[:name])
    space.update!(space_attributes.except(:name, :rooms, :members))

    space_attributes.fetch(:rooms, []).each do |room_attributes|
      room = space.rooms.find_or_initialize_by(name: room_attributes[:name])
      room.update!(room_attributes.except(:name, :furniture_placements))
      furniture_placements = room_attributes.fetch(:furniture_placements, {})
      furniture_placements.each.with_index do |(furniture, settings), slot|
        furniture_placement = room.furniture_placements
                                  .find_or_initialize_by(slot: slot)
        furniture_placement.update!(settings: settings, furniture_kind: furniture)
      end
    end

    space_attributes.fetch(:members, []).each do |member_attribute|
      person = Person.find_or_initialize_by(member_attribute[:email])
      person.update!(member_attribute[:password])
      profile = Profile.find_or_initialize_by
      space.members << person
    end

    space
  end

  private def space
    @_space ||= client.spaces.find_or_create_by!(space_attributes[:name])
  end

  private def client
      @_client ||= Client.find_or_create_by!(name: client_attributes[:name])
  end

  private def client_attributes
    attributes[:client]
  end

  private def space_attributes
    client_attributes[:space]
  end
end
