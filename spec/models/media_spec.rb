require "rails_helper"

RSpec.describe Media, type: :model do
  it { is_expected.to have_one_attached(:upload) }
end
