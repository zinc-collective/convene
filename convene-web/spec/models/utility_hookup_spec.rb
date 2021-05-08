# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UtilityHookup, type: :model do
  describe '#name' do
    it 'defaults to the humanized version of the hookup slug' do
      utility_hookup = UtilityHookup.new(utility_slug: :null_hookup)
      expect(utility_hookup.name).to eql('Null hookup')
    end
  end

  describe '#utility' do
    it 'exposes its configuration' do
      utility_hookup = UtilityHookup.new(utility_slug: :null_hookup, configuration: { a: :b })
      expect(utility_hookup.utility).to be_a(Utilities::NullUtility)
      expect(utility_hookup.utility.configuration['a']).to eql('b')
    end
  end
end
