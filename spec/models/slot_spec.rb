require "rails_helper"

RSpec.describe Slot do
  it { is_expected.to belong_to(:section).class_name(:Room) }
  it { is_expected.to belong_to(:slottable) }
end
