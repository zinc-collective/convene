# frozen_string_literal: true

# Groups the {Furniture} definitions and provides supporting functionality for
# folks defining new Furniture.
module Furniture
  REGISTRY = {
    journal: Journal,
    markdown_text_block: MarkdownTextBlock,
    marketplace: Marketplace,
    livestream: Livestream,
    embedded_form: EmbeddedForm,
  }.freeze

  # Appends each Furnitures CRUD actions within the {Room}
  def self.append_routes(router)
    REGISTRY.each_value do |furniture|
      furniture.append_routes(router) if furniture.respond_to?(:append_routes)
    end
  end

  # @return [FurniturePlacement]
  def self.from_placement(placement)
    furniture_class = REGISTRY[placement.furniture_kind.to_sym]
    furniture_class.from_placement(placement)
  end
end
