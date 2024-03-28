class TextBlock
  class TextBlockPolicy < ApplicationPolicy
    alias_method :text_block, :object
    def create?
      current_person.member_of?(text_block.space)
    end

    class Scope < ApplicationScope
    end
  end
end
