# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkdownTextBlock do
  subject { described_class.new(placement: create(:furniture_placement)) }

  describe '#to_html' do
    it 'renders markdown correctly' do
      subject.content = <<~MARKDOWN
        # Title
        ## Subtitle
        * item the first
        * item the _second_
      MARKDOWN
      expect(subject.to_html).to include '<h1 id="title">Title</h1>'
      expect(subject.to_html).to include '<h2 id="subtitle">Subtitle</h2>'
      expect(subject.to_html).to include '<li>item the first</li>'
      expect(subject.to_html).to include '<li>item the <em>second</em></li>'
    end
  end
end
