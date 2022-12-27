# frozen_string_literal: true

# Standard permissions for how Utilities can be managed.
# Can be overridden on a per-Utility basis.
class UtilityPolicy < UtilityHookupPolicy
  alias_method :utility, :object
end
