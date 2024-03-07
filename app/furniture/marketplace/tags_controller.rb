# frozen_string_literal: true

class Marketplace
  class TagsController < Controller
    # Apparently, `tag` is used inside of `turbo_frame_tag`, so if we define a
    # helper_method named `tag` our method gets called when it really shouldn't
    # be... so `mtag` it is. For now.
    expose :mtag, scope: -> { tags }, model: Tag
    expose :tags, -> { policy_scope(bazaar.tags.create_with(marketplace: marketplace)) }

    def new
      authorize(mtag)
    end

    def create
      if authorize(mtag).save
        redirect_to marketplace.location(child: :tags)
      else
        render :new
      end
    end

    def index
      skip_authorization
    end

    def mtag_params
      policy(Tag).permit(params.require(:tag))
    end
  end
end
