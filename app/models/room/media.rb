class Room
  class Media < ApplicationRecord
    has_one_attached :file
  end
end
