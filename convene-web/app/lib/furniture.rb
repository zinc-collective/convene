module Furniture
  REGISTRY = {
    tables: Furniture::BreakoutTables,
    breakout_tables: Furniture::BreakoutTables,
    videobridge_jitsi: Furniture::VideobridgeJitsi,
  }

  def self.from_placement(placement)
    REGISTRY[placement.name.to_sym].new(placement)
  end
end
