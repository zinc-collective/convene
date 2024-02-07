# The Media resource manages file uploads to the platform
class Media < ApplicationRecord
  # NOTE: Dependent destroy is defaulted, but when it becomes important to
  # separate the destroy request and purge operations, let's add the
  # `dependent: :purge_later` option.
  has_one_attached :upload
end
