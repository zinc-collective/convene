module RendersMarkdown
  def render_markdown(content)
    self.class.renderer.render(content)
  end

  def self.renderer
    @_renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(filter_html: true, with_toc_data: true),
      autolink: true, strikethrough: true,
      no_intra_emphasis: true,
      lax_spacing: true,
      fenced_code_blocks: true, disable_indented_code_blocks: true,
      tables: true, footnotes: true, superscript: true, quote: true
    )
  end
end
