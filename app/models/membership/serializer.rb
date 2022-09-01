# frozen_string_literal: true

class Membership::Serializer < ApplicationSerializer
  # @return [Membership]
  alias membership resource
  def to_json(*_args)
    super.merge(
      membership: {
        id: membership.id,
        member: {
          id: membership.member&.id
        },
        space: {
          id: membership.space&.id
        }
      }
    )
  end
end
