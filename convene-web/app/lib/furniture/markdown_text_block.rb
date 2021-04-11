# frozen_string_literal: true

module Furniture
  # Renders some HTML in a {Room}.
  class MarkdownTextBlock
    include Placeable
    attribute :content, :string

    def to_html
      MarkdownTextBlock.renderer.render(content)
    end

    def content=(content)
      settings['content'] = content
      _write_attribute('content', content)
    end

    alias :text= :content=

    def content
      settings['content'] || super
    end

    def self.renderer
      @_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(with_toc_data: true))
    end
  end
end
