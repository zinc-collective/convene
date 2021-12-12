# frozen_string_literal: true

# Standard permissions for how Utilities can be managed.
# Can be overridden on a per-Utility basis.
class UtilityPolicy
  attr_accessor :person, :utility
  def initialize(person, utility)
    self.person = person
    self.utility = utility
  end
end
