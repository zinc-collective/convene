# frozen_string_literal: true

class Spotlight
  class Image < Item
    has_one_attached :file
    def alt_text=text
      data["alt_text"] = text
    end

    def alt_text
      data["alt_text"]
    end
  end
end
