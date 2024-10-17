class SlotPolicy < ApplicationPolicy
  alias_method :slot, :object

  def create?
    current_person.operator? || current_person.member_of?(slot.space)
  end

  class Scope < ApplicationScope
  end
end
