module Furniture
  REGISTRY = {
    breakout_tables: Furniture::BreakoutTablesByJitsi,
    videobridge_jitsi: Furniture::VideobridgeByJitsi,
  }

  # Allows Furniture to expose their controllers
  def self.append_routes(routing_context)
    REGISTRY.values.each do |furniture|
      furniture.append_routes(routing_context) if furniture.respond_to?(:append_routes)
    end
  end

  def self.from_placement(placement)
    REGISTRY[placement.name.to_sym].new(placement)
  end
end
