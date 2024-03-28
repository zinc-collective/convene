class TextBlock
  class TextBlocksController < ApplicationController
    expose :text_block, scope: -> { policy_scope(TextBlock, policy_scope_class: TextBlockPolicy::Scope) }, model: TextBlock,
      build: ->(params, scope) { scope.new(params.merge(slottable: slottable)) }

    def new
      authorize(text_block, policy_class: TextBlockPolicy)
    end
  end
end
