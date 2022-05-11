# frozen_string_literal: true

class EmbeddedImage
  class ImageFile < Item
    has_one_attached :file
  end
end
