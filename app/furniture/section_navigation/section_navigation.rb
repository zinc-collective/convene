class SectionNavigation
  class SectionNavigation < Furniture
    location(parent: :room)
    default_scope { where(furniture_kind: "section_navigation") }

    def rooms
      space.rooms.where.not(id: space.entrance_id)
    end
  end
end
