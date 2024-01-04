# frozen_string_literal: true

class MembershipPolicy < ApplicationPolicy
  alias_method :membership, :object
  delegate :space, to: :membership
  def create?
    person.operator? || person_responding_to_invitation_to_space?
  end

  def destroy?
    return false if membership.member == person

    person.operator? || person.member_of?(space)
  end

  def show?
    person.operator? || membership.member == person || person.member_of?(space)
  end

  private def person_responding_to_invitation_to_space?
    membership.member.email == person.email && space.invitations.exists?(status: %i[pending], email: person.email)
  end

  class Scope < ApplicationScope
    def resolve
      if person.operator?
        scope.all
      else
        scope.where(space: person.spaces)
      end
    end
  end
end
