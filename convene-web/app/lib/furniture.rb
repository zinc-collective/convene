# frozen_string_literal: true

module Furniture
  REGISTRY = {
    breakout_tables_by_jitsi: Furniture::BreakoutTablesByJitsi,
    videobridge_by_jitsi: Furniture::VideobridgeByJitsi,
    markdown_text_block: Furniture::MarkdownTextBlock
  }

  # Allows Furniture to expose their controllers
  def self.append_routes(routing_context)
    REGISTRY.values.each do |furniture|
      furniture.append_routes(routing_context) if furniture.respond_to?(:append_routes)
    end
  end

  def self.from_placement(placement)
    REGISTRY[placement.furniture_kind.to_sym].new(placement: placement)
  end
end
