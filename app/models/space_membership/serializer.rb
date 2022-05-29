# frozen_string_literal: true

class SpaceMembership::Serializer < ApplicationSerializer
  # @return [SpaceMembership]
  alias space_membership resource
  def to_json(*_args)
    super.merge(
      space_membership: {
        id: space_membership.id,
        member: {
          id: space_membership.member&.id
        },
        space: {
          id: space_membership.space&.id
        }
      }
    )
  end
end
