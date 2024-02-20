# The Media resource manages file uploads to the platform
class Media < ApplicationRecord
  # 16:9 of 1290 is 1290:725.625
  # We rounded up.
  # @see https://www.ios-resolution.com/
  FULL_WIDTH_16_BY_9 = [1290, 726]
  FULL_WIDTH_SHORT = [1728, 480]

  # NOTE: Dependent destroy is defaulted, but when it becomes important to
  # separate the destroy request and purge operations, let's add the
  # `dependent: :purge_later` option.
  has_one_attached :upload
end
