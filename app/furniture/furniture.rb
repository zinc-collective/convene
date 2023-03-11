# frozen_string_literal: true

# Groups the {Furniture} definitions and provides supporting functionality for
# folks defining new Furniture.
module Furniture
  REGISTRY = {
    journal: Journal::Journal,
    markdown_text_block: MarkdownTextBlock,
    marketplace: Marketplace::Marketplace,
    livestream: Livestream,
    embedded_form: EmbeddedForm
  }.freeze

  # Appends each Furnitures CRUD actions within the {Room}
  def self.append_routes(router)
    REGISTRY.each_value do |furniture|
      furniture.router&.append_routes(router)
    end
  end

  # @return [FurniturePlacement]
  def self.from_placement(placement)
    furniture_class = REGISTRY.fetch(placement.furniture_kind.to_sym)
    placement.becomes(furniture_class)
  end
end
