# frozen_string_literal: true

require "rails_helper"

RSpec.describe MarkdownTextBlock do
  subject(:content_block) { create(:furniture).becomes(described_class) }

  describe "#to_html" do
    it "renders markdown correctly" do
      content_block.content = <<~MARKDOWN
        # Title
        ## Subtitle
        * item the first
        * item the _second_
      MARKDOWN
      expect(content_block.to_html).to include '<h1 id="title">Title</h1>'
      expect(content_block.to_html).to include '<h2 id="subtitle">Subtitle</h2>'
      expect(content_block.to_html).to include "<li>item the first</li>"
      expect(content_block.to_html).to include "<li>item the <em>second</em></li>"
    end
  end
end
