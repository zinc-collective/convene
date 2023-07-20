# frozen_string_literal: true

class Journal
  class KeywordPolicy < ApplicationPolicy
    alias_method :keyword, :object

    def show?
      true
    end

    class Scope < ApplicationScope
      def resolve
        scope
      end
    end
  end
end
