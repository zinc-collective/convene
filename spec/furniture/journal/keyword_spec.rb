# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal::Keyword, type: :model do
  it { is_expected.to validate_presence_of(:canonical_keyword) }
  it { is_expected.to validate_uniqueness_of(:canonical_keyword).case_insensitive.scoped_to(:journal_id) }
  it { is_expected.to belong_to(:journal).inverse_of(:keywords) }
end
