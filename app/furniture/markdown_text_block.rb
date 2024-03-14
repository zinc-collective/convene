# frozen_string_literal: true

# Renders some HTML in a {Room}.
class MarkdownTextBlock < Furniture
  include RendersMarkdown
  location(parent: :room)
  has_rich_text :action_content

  # setting :content, default: ""

  def to_html
    render_markdown(content)
  end

  # @todo can we make it so we don't need to define this?
  # and the `settings.fetch` bits?
  def attribute_names
    super + ["content", "action_content"]
  end

  def form_template
    "markdown_text_blocks/form"
  end
end
