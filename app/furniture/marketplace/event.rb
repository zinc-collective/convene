class Marketplace
  class Event < Record
    self.table_name = "marketplace_events"
    location(parent: :regarding)
    belongs_to :regarding, inverse_of: :events, polymorphic: true
  end
end
