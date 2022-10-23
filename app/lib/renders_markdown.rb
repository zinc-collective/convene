module RendersMarkdown
  def render_markdown(content)
    CommonMarker.render_doc(content, :DEFAULT).to_html
  end
end
