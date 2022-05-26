# frozen_string_literal: true

class Spotlight
  include Placeable

  def self.append_routes(router)
    router.scope module: 'spotlight' do
      router.resource :spotlight, only: [:show] do
        router.resources :image_files, only: %i[create edit update]
      end
    end
  end

  def image_file
    ImageFile.find_or_initialize_by(location: placement, space: placement.space)
  end
end
