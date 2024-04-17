require "rails_helper"

RSpec.describe BrandHeaderComponent, type: :component do
  let(:space) { create(:space, :with_entrance) }
  let!(:room) { create(:room, space: space) }

  it "renders the correct room names" do
    render_inline(described_class.new(space: space)).text

    expect(page).to have_text space.name
    expect(page).to have_text space.entrance.name
    expect(page).to have_text room.name
  end
end
