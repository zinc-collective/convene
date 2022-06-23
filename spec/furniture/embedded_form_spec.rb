# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmbeddedForm do
  describe '#embeddable_form_url' do
    it 'converts Airtable Share URLs into the Embed url' do
      embedded_form = build(:embedded_form, form_url: 'https://airtable.com/shrCnrBzflvzDIlvg')
      expect(embedded_form.embeddable_form_url).to eql('https://airtable.com/embed/shrCnrBzflvzDIlvg')

      embedded_form = build(:embedded_form, form_url: 'https://airtable.com/shrCnrBzflvzDIlvg/embed')
      expect(embedded_form.embeddable_form_url).to eql('https://airtable.com/embed/shrCnrBzflvzDIlvg')

      embedded_form = build(:embedded_form, form_url: 'https://airtable.com/embed/shrCnrBzflvzDIlvg')
      expect(embedded_form.embeddable_form_url).to eql('https://airtable.com/embed/shrCnrBzflvzDIlvg')
    end
  end
end
