class Journal
  class Renderer < Redcarpet::Render::Safe
    def autolink(link, link_type)
      return link if link_type == :email
      "<a href=\"#{link}\">#{link}</a>"
    end

    def postprocess(doc)
      doc.gsub(/@([a-zA-Z\d]*)@(.*\.[a-zA-Z]*)/, '<a href="https://\2/@\1">@\1@\2</a>')
    end
  end
end
