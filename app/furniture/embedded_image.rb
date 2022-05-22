# frozen_string_literal: true

class EmbeddedImage
  include Placeable

  def self.append_routes(router)
    router.scope module: 'embedded_image' do
      router.resource :embedded_image, only: [:show] do
        router.resources :image_files, only: %i[create update]
      end
    end
  end

  def image_file
    ImageFile.find_or_initialize_by(location: placement, space: placement.space)
  end
end
