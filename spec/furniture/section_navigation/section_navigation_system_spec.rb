require "rails_helper"
require_relative "factories"

RSpec.describe SectionNavigation, type: :system do
  let(:space) { create(:space, :with_entrance) }
  let(:rooms) { create_list(:room, 2, space:) }

  it "includes a link to every section except the entrance" do
    create(:section_navigation, room: space.entrance)

    visit polymorphic_path(space.entrance.location)

    rooms.each do |room|
      within("##{dom_id(room, :link_to)}") do
        expect(page).to have_link(room.name, href: polymorphic_path(room.location))
        expect(page).to have_content(rooms.description)
      end
    end

    expect(page).not_to have_link(space.entrance.name, href: polymorphic_path(space.entrance.location))
  end
end
