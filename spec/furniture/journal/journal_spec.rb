# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal::Journal, type: :model do
  it { is_expected.to have_many(:entries).inverse_of(:journal).dependent(:destroy) }
  it { is_expected.to have_many(:keywords).inverse_of(:journal).dependent(:destroy) }
end
