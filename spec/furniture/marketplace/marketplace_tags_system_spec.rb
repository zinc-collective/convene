require "rails_helper"

describe "Marketplace Tags", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  scenario "Add a marketplace tag" do
    visit(marketplace)
    click_link("Tags")
    click_link("Add Product Tag")
    fill_in("Label", with: "🚫🌾 Gluten Free")
    click_button("Create")
    expect(page).to have_content("🚫🌾 Gluten Free")
  end

  scenario "Edit a Marketplace Tag" do
    visit(marketplace)
    click_link("Tags")
    click_link("Add Product Tag")
    fill_in("Label", with: "🚫🌾 Gluten Free")
    click_button("Create")
    expect(page).to have_content("🚫🌾 Gluten Free")

    click_link("🚫🌾 Gluten Free")
    fill_in("Label", with: "🌾 Very Glutenous")
    click_button("Save changes")
    expect(page).to have_content("🌾 Very Glutenous")

    click_link("🌾 Very Glutenous")
    check("tag_is_group")
    click_button("Save changes")
    within("[data-tag-list-test]") do
      expect(page).to have_content("🌾 Very Glutenous")
    end
  end

  describe "Menu Groups" do
    let!(:menu_tags) do
      # The positioning gem won't let us manually assign positions on creation
      create_list(:marketplace_tag, 3, :group, marketplace: marketplace).tap do |tags|
        tags[0].update(position: :last)
        tags[2].update(position: :first)
      end
    end

    scenario "Displays Menu Groups in the correct order" do
      visit(marketplace)
      click_link("Tags")
      within("[data-tag-list-test]") do
        expect(page.find("li:nth-child(1)")).to have_content(menu_tags[2].label)
        expect(page.find("li:nth-child(2)")).to have_content(menu_tags[1].label)
        expect(page.find("li:nth-child(3)")).to have_content(menu_tags[0].label)
      end
    end
  end

  def visit(object_or_path)
    if object_or_path.respond_to?(:location)
      super(polymorphic_path(object_or_path.location))
    else
      super
    end
  end
end
