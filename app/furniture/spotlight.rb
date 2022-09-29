# frozen_string_literal: true

class Spotlight
  include Placeable
  delegate :alt_text,:alt_text=, to: :image

  def self.append_routes(router)
    router.scope module: 'spotlight' do
      router.resource :spotlight, only: [:show] do
        router.resources :images, only: %i[create edit update]
      end
    end
  end

  def image
    Image.find_or_initialize_by(location: placement, space: placement.space)
  end

  def alt_text=text
    image.update(alt_text:text)
  end

  def file=file
    image.file.attach(file)
  end

  def attribute_names
    %w[file alt_text]
  end
end
