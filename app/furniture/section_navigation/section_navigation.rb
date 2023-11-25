class SectionNavigation
  class SectionNavigation < Furniture
    location(parent: :room)

    def rooms
      space.rooms.where.not(id: space.entrance_id)
    end
  end
end
