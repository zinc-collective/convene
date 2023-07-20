class Journal
  class EntryComponent < ApplicationComponent
    include RendersMarkdown
    attr_accessor :entry

    def initialize(*args, entry:, **kwargs)
      self.entry = entry
      super(*args, **kwargs)
    end

    def body_html
      render_markdown(entry.body)
    end

    def published_at
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
