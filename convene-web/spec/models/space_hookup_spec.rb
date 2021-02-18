# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpaceHookup, type: :model do
  describe '#name' do
    it 'defaults to the humanized version of the hookup slug' do
      x = SpaceHookup.new(hookup_slug: :null_hookup)
      expect(x.name).to eql('Null hookup')
    end
  end

  describe '#hookup' do
    it 'exposes its configuration' do
      x = SpaceHookup.new(hookup_slug: :null_hookup, configuration: { a: :b })
      expect(x.hookup).to be_a(Hookups::NullHookup)
      expect(x.hookup.configuration.get(:a)).to eql('b')
    end
  end
end
