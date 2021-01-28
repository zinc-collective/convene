# Used to assemble Spaces
class Blueprint
  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def find_or_create!
    space = client.spaces.find_or_create_by!(space_attrs[:name])
    space.update!(space_attrs.except(:name))

    room_attrs.each do |room_attrs|
      room = space.rooms.find_or_initialize_by(name: room_attrs[:name])
      room.update!(room_attrs.except(:name))
      furniture_placements = room_attrs.fetch(:furniture_placements, {})
      furniture_placements.each.with_index do |(furniture, settings), slot|
        furniture_placement = room.furniture_placements
                                  .find_or_initialize_by(name: furniture)
        furniture_placement.update!(settings: settings, slot: slot)
      end
    end

    space
  end

  private def space
    @_space ||= client.spaces.find_or_create_by!(space_attrs[:name])
  end

  private def client
      @_client ||= Client.find_or_create_by!(name: client_attrs[:name])
  end

  private def client_attrs
    attributes[:client]
  end

  private def space_attrs
    client_attrs[:space]
  end
end
