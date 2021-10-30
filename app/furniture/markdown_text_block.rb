# frozen_string_literal: true

# Renders some HTML in a {Room}.
class MarkdownTextBlock
  include Placeable

  def to_html
    MarkdownTextBlock.renderer.render(content)
  end

  def content=(content)
    settings['content'] = content
  end

  def content
    settings.fetch('content', '')
  end

  def attribute_names
    super + ['content']
  end

  def self.renderer
    @_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(with_toc_data: true))
  end
end