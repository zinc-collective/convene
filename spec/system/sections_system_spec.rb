require "rails_helper"

RSpec.describe "Sections" do
  describe "Removing a Section" do
    let(:space) { create(:space, :with_entrance, :with_members, member_count: 1) }

    before do
      sign_in(space.members.first, space)
      visit(polymorphic_path(section.location(:edit)))
    end

    context "when the section is an entrance" do
      let(:section) { space.entrance }

      it "doesn't let you delete the entrance" do
        expect(page).to have_content(I18n.t("rooms.destroy.blocked_by_entrance", room_name: section.name))
        expect(page).not_to have_content(I18n.t("rooms.destroy.link_to"))
      end
    end

    context "when the section is not the entrance" do
      let(:section) { create(:room, space: space) }

      context "when the Section has no Gizmos" do
        it "deletes the Section from the Database" do
          click_button(I18n.t("rooms.destroy.link_to"))

          expect(page).to have_content(I18n.t("rooms.destroy.success", room_name: section.name))
          expect(space.rooms).not_to be_exist(id: section.id)
        end
      end

      context "when the section has Gizmos" do
        before {
          create(:furniture, room: section)
          refresh
        }

        # Design note: It would be far better for us to have a way to safely undo
        # the deletion of a Section, or even put the Gizmos into a holding space
        # or something to be re-assigned; but that is out of scope for me at the
        # moment - ZS 10/18/23
        it "does not allow deletion of the Section" do
          expect(page).to have_content(I18n.t("rooms.destroy.blocked_by_gizmos", room_name: section.name))
          expect(page).not_to have_content(I18n.t("rooms.destroy.link_to"))
        end
      end
    end
  end
end
