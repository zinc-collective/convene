# frozen_string_literal: true

class Marketplace
  class TagsController < Controller
    # Apparently, `tag` is used inside of `turbo_frame_tag`, so if we define a
    # helper_method named `tag` our method gets called when it really shouldn't
    # be... so `mtag` it is. For now.
    expose :mtag, scope: -> { tags }, model: Tag
    expose :tags, -> { policy_scope(marketplace.tags.create_with(marketplace: marketplace)) }

    def new
      authorize(mtag)
    end

    def edit
      authorize(mtag)
    end

    def update
      if authorize(mtag).update(mtag_params)
        # POST requests to reorder tags (Stimulus Sortable) are sent with an
        # html content-type so they cannot be handled by a JS responder.
        if request.xhr?
          render json: {}, status: :ok
        else
          redirect_to marketplace.location(child: :tags)
        end
      else
        render :edit
      end
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

    def destroy
      authorize(mtag).destroy

      respond_to do |format|
        format.turbo_stream do
          if mtag.destroyed?
            render turbo_stream: turbo_stream.remove(mtag)
          else
            render turbo_stream: turbo_stream.replace(mtag)
          end
        end
      end
    end

    def mtag_params
      policy(Tag).permit(params.require(:tag))
    end
  end
end
