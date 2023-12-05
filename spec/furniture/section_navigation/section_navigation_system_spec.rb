require "rails_helper"
require_relative "factories"

RSpec.describe SectionNavigation, type: :system do
  it "includes a link to every section except the entrance" do
    space = create(:space, :with_entrance)
    rooms = create_list(:room, 2, space:)
    create(:section_navigation, room: space.entrance)

    visit polymorphic_path(space.entrance.location)

    expect(page).to have_link(rooms.first.name, href: polymorphic_path(rooms.first.location))
    expect(page).to have_link(rooms.last.name, href: polymorphic_path(rooms.last.location))
    expect(page).not_to have_link(space.entrance.name, href: polymorphic_path(space.entrance.location))
  end
end
