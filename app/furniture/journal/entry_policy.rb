# frozen_string_literal: true

class Journal
  class EntryPolicy < ApplicationPolicy
    alias entry object

    def create?
      person&.member_of?(entry.space)
    end

    def show?
      update? || entry.published?
    end

    def update?
      create?
    end

    def permitted_attributes(_params)
      %i[headline body]
    end

    class Scope < ApplicationScope
      def resolve
        scope.where('published_at < ?', Time.zone.now)
             .or(scope.where(room: person.rooms))
      end
    end
  end
end
