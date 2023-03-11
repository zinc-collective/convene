# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmbeddedForm do
  subject(:embedded_form) { build(:embedded_form, form_url: form_url) }

  describe "#embeddable_form_url" do
    subject(:embeddable_form_url) { embedded_form.embeddable_form_url }

    context "with a #form_url that is the basic share url" do
      let(:form_url) { "https://airtable.com/shrCnrBzflvzDIlvg" }

      it { is_expected.to eql "https://airtable.com/embed/shrCnrBzflvzDIlvg" }
    end

    context "with a #form_url that is the embed instructions url" do
      let(:form_url) { "https://airtable.com/shrCnrBzflvzDIlvg/embed" }

      it { is_expected.to eql("https://airtable.com/embed/shrCnrBzflvzDIlvg") }
    end

    context "with a #form_url that is the actual embed url" do
      let(:form_url) { "https://airtable.com/embed/shrCnrBzflvzDIlvg" }

      it { is_expected.to eql("https://airtable.com/embed/shrCnrBzflvzDIlvg") }
    end
  end
end
