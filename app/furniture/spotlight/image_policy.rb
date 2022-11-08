# frozen_string_literal: true

class Spotlight
  class ImagePolicy < ApplicationPolicy
    def index?
      true
    end

    def create?
      person.member_of?(object.space)
    end

    def update?
      create?
    end

    def permitted_attributes(_params)
      %i[file]
    end

    class Scope < ApplicationScope
      def resolve
        if person.spaces.include?(scope.space)
          scope
        end
      end
    end
  end
end
