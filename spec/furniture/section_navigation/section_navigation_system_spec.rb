require "rails_helper"
require_relative "factories"

RSpec.describe SectionNavigation, type: :system do
  let(:space) { create(:space, :with_entrance) }

  it "includes a link to every section except the entrance" do
    rooms = create_list(:room, 2, :with_description, space:)

    create(:section_navigation, room: space.entrance)

    visit polymorphic_path(space.entrance.location)

    rooms.each do |room|
      expect(page).to have_link(room.name, href: polymorphic_path(room.location))
      within("##{dom_id(room, :link_to)}") do
        expect(page).to have_content(room.description)
      end
    end

    expect(page).not_to have_link(space.entrance.name, href: polymorphic_path(space.entrance.location))
  end
end
