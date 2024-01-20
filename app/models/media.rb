# The Media resource manages file uploads to the platform
class Media < ApplicationRecord
  has_one_attached :upload
end
