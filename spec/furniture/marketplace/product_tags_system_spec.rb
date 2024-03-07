require "rails_helper"

describe "Product Tags", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  scenario "Adding Tags to a Product" do # rubocop:disable RSpec/Capybara/FeatureMethods,RSpec/ExampleLength
    muffins = create(:marketplace_product, marketplace:, name: "Mazin' Muffins", description: "Buttery corn muffins")

    visit(marketplace)
    click_link("Tags")

    click_link("Add Tag")

    fill_in("Label", with: "🚫🌾 Gluten Free")

    click_button("Create")

    click_link("Products")
    within(muffins) do
      click_link("⚙️ Edit")
    end

    check("🚫🌾 Gluten Free")
    click_button("Save")

    visit(marketplace)

    within(muffins) do
      expect(page).to have_content("🚫🌾 Gluten Free")
    end
  end

  def visit(object_or_path)
    if object_or_path.respond_to?(:location)
      super(polymorphic_path(object_or_path.location))
    else
      super
    end
  end

  def within(model, *, **, &block)
    page.within("##{dom_id(model)}", *, **, &block)
  end
end
