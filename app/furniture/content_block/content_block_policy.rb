class ContentBlock
  class ContentBlockPolicy < ApplicationPolicy
    alias_method :content_block, :object
    def create?
      current_person.member_of?(content_block.space)
    end

    class Scope < ApplicationScope
    end
  end
end
