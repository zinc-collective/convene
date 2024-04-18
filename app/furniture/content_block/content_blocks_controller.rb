class ContentBlock
  class ContentBlocksController < ApplicationController
    expose :content_block, scope: -> { policy_scope(ContentBlock, policy_scope_class: ContentBlockPolicy::Scope) }, model: ContentBlock

    def new
      authorize(content_block, policy_class: ContentBlockPolicy)
    end
  end
end
