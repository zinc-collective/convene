# frozen_string_literal: true

class Spotlight
  class ImageFile < Item
    has_one_attached :file
  end
end
