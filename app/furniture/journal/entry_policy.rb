# frozen_string_literal: true

class Journal
  class EntryPolicy < ApplicationPolicy
    alias_method :entry, :object

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
      %i[headline summary body published_at]
    end

    class Scope < ApplicationScope
      def resolve
        scope.includes(:journal).where("published_at < ?", Time.zone.now)
          .or(scope.includes(:journal).where(journal: {room: person.rooms}))
      end
    end
  end
end
