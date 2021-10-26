require 'rails_helper'

RSpec.describe Utilities::Plaid, type: :model do
  it { is_expected.to validate_presence_of :client_id }
  it { is_expected.to validate_presence_of :secret }
  it { is_expected.to validate_presence_of :version }
  it { is_expected.to validate_presence_of :environment }
  it do
    is_expected.to validate_inclusion_of(:environment).in_array(described_class::AVAILABLE_ENVIRONMENTS)
  end
end