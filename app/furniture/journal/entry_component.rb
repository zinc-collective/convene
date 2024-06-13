class Journal
  class EntryComponent < ApplicationComponent
    include RendersMarkdown
    attr_accessor :entry

    def initialize(*, entry:, **)
      self.entry = entry
      super(*, **)
    end

    def body_html
      postprocess(render_markdown(entry.body))
    end

    private def postprocess(text)
      entry.keywords.by_length.map do |keyword|
        linkify_keyword(text, keyword)
      end

      text
    end

    private def linkify_keyword(text, keyword)
      text.gsub!(keywords_regex(keyword)) do |match|
        link_to(match.gsub("#", "&#35;").html_safe, keyword.location) # rubocop:disable Rails/OutputSafety
      end
    end

    # We sort the variants longest to shortest because regex matches groups left-to-right
    private def keywords_regex(keyword)
      /(\##{keyword.canonical_with_aliases.sort.reverse.join("|#")})/i
    end

    private def published_at
      entry.published_at.to_fs(:long_ordinal)
    end

    def self.renderer
      @_renderer ||= Redcarpet::Markdown.new(
        Renderer.new(filter_html: true, with_toc_data: true),
        autolink: true, strikethrough: true,
        no_intra_emphasis: true,
        lax_spacing: true,
        fenced_code_blocks: true, disable_indented_code_blocks: true,
        tables: true, footnotes: true, superscript: true, quote: true
      )
    end
  end
end
