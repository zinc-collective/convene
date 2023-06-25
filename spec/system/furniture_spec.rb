require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/709
describe "Furniture" do
  include ActiveJob::TestHelper
  it "Managing Furniture" do
    space = create(:space, :with_entrance, :with_members, member_count: 1)
    sign_in(space.members.first, space)

    add_gizmo("Markdown Text Block", room: space.entrance)
    remove_gizmo("Markdown Text Block", room: space.entrance)

    visit(polymorphic_path(space.entrance.location(:edit)))
    expect(page).to have_text("No gizmos yet.")
  end

  def sign_in(user, space)
    visit(polymorphic_path(space.location))
    click_link_or_button("Sign in")
    fill_in("authenticated_session[contact_location]", with: user.email)
    find('input[type="submit"]').click
    perform_enqueued_jobs

    visit(URI.parse(URI.extract(ActionMailer::Base.deliveries.first.body.to_s)[1]).request_uri)
  end

  def add_gizmo(type, room:)
    visit(polymorphic_path(room.location(:edit)))
    select(type, from: "Type of gizmo")
    click_link_or_button("Add Gizmo")
  end

  def remove_gizmo(type, room:)
    visit(polymorphic_path(room.location(:edit)))
    expect(page).to have_text("Markdown Text Block")
    within("##{ActionView::RecordIdentifier.dom_id(room.gizmos.first)}") do
      click_link_or_button "Configure Markdown Text Block"
    end
    click_link_or_button "Remove Gizmo"
  end
end
