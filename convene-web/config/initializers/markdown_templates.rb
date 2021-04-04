# This allows us to define partials as markdown, which may be useful for guides and such.
# @see https://bloggie.io/@kinopyo/rails-render-markdown-views-and-partials
# @see https://edgeapi.rubyonrails.org/classes/ActionView/Template/Handlers/ERB.html
class MarkdownTemplateHandler
  def erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def call(template, source)
    erb.call(template, renderer.render(source))
  end

  private def renderer
    @_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(with_toc_data: true))
  end
end

ActionView::Template.register_template_handler(:md, :markdown, MarkdownTemplateHandler.new)
