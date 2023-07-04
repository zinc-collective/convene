# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal::Term, type: :model do
  it { is_expected.to belong_to(:journal).inverse_of(:terms) }
end
