class Furniture::Serializer < ApplicationSerializer
  # @return [Furniture]
  alias_method :furniture, :resource

  def to_json(*_args)
    super.merge(
      furniture: {
        id: furniture.id
      }
    )
  end
end
