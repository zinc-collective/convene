require "rails_helper"

RSpec.describe Slot do
  it { is_expected.to belong_to(:section).class_name(:Room).inverse_of(:slots) }
  it { is_expected.to belong_to(:slottable).inverse_of(:slot) }
end
