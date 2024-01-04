# frozen_string_literal: true

require "rails_helper"

RSpec.describe MarkdownTextBlock do
  subject(:content_block) { create(:markdown_text_block).becomes(described_class) }

  describe "#to_html" do
    subject(:to_html) { content_block.to_html }

    before do
      content_block.content = <<~MARKDOWN
        # Title
        ## Subtitle
        * item the first
        * item the _second_
      MARKDOWN
    end

    it { is_expected.to include '<h1 id="title">Title</h1>' }
    it { is_expected.to include '<h2 id="subtitle">Subtitle</h2>' }
    it { is_expected.to include "<li>item the first</li>" }
    it { is_expected.to include "<li>item the <em>second</em></li>" }
  end
end
