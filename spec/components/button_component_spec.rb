# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  describe "#render" do
    subject(:output) { render_inline(component) }

    let(:component) { described_class.new(**params) }
    let(:params) { {label: "Some label", title: "Our Title", href: "somewhere.com"} }

    let(:a_el) { output.at_css("a") }

    it "renders a link with the given arguments" do
      expect(a_el).to be_present
      expect(a_el.text).to include("Some label")
      expect(a_el["title"]).to eq("Our Title")
      expect(a_el["href"]).to eq("somewhere.com")
    end

    context "when confirm is false" do
      let(:component) { described_class.new(**params.merge({confirm: false})) }

      it "does not include confirm nor turbo-confirm" do
        expect(a_el.attributes).not_to include("data-confirm")
        expect(a_el.attributes).not_to include("data-turbo-confirm")
      end
    end

    context "when confirm is present" do
      let(:confirm_text) { "you sure????" }
      let(:component) { described_class.new(**params.merge({confirm: confirm_text})) }

      it "includes confirm and turbo-confirm" do
        expect(a_el.attributes["data-confirm"].value).to eq(confirm_text)
        expect(a_el.attributes["data-turbo-confirm"].value).to eq(confirm_text)
      end
    end

    context "when disabled is true" do
      let(:component) { described_class.new(**params.merge({disabled: true})) }

      it "does not render a link" do
        expect(a_el).not_to be_present
      end

      it "renders a span with the label" do
        expect(output.at_css("span")).to be_present
        expect(output.at_css("span").text).to eq("Some label")
      end
    end

    context "when the scheme is `:danger`" do
      let(:component) { described_class.new(**params.merge({scheme: :danger})) }

      it { expect(a_el.attributes["class"].value).to eq("button --danger") }
    end
  end
end
