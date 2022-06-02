# frozen_string_literal: true

class Spotlight
  class Image < Item
    has_one_attached :file
  end
end
