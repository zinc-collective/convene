require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/709
describe "Furniture" do
  it "Managing Furniture" do
    space = create(:space, :with_entrance, :with_members, member_count: 1)
    sign_in(space.members.first, space)

    add_gizmo("Markdown Text Block", room: space.entrance)
    remove_gizmo("Markdown Text Block", room: space.entrance)

    visit(polymorphic_path(space.entrance.location(:edit)))
    expect(page).to have_text("No gizmos yet.")
  end

  def add_gizmo(type, room:)
    visit(polymorphic_path(room.location(:edit)))
    select(type, from: "furniture_furniture_kind")
    click_button("Add Gizmo")
  end

  def remove_gizmo(type, room:)
    visit(polymorphic_path(room.location(:edit)))
    expect(page).to have_text("Markdown Text Block")
    within("##{dom_id(room.gizmos.first)}") do
      click_link "Configure Markdown Text Block"
    end
    click_link "Remove Gizmo"
  end
end
