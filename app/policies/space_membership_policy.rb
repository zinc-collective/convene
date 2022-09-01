# frozen_string_literal: true

class SpaceMembershipPolicy < ApplicationPolicy
  alias space_membership object
  delegate :space, to: :space_membership
  def create?
    person.operator? || person_responding_to_invitation_to_space?
  end

  def destroy?
    person.operator? ||
    person.member_of?(space) ||
    person == space_membership.member
  end

  private def person_responding_to_invitation_to_space?
    (space_membership.member.email == person.email && space.invitations.exists?(status: %i[pending], email: person.email))
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(space: person.spaces)
    end
  end
end
