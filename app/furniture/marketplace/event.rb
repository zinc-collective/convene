# Marketplace Order Events track meaningful occurrences in the lifecycle of an
# order for use in order management workflows or analysis.
#
# For now, event descriptions are keyed by hand as free text but should follow
# the following stylistic conventions:
#   1. Title Case
#   2. Noun + Verb
#   3. Past tense
# For example: `order.events.create(description: "Payment Received")
class Marketplace
  class Event < Record
    self.table_name = "marketplace_events"
    location(parent: :regarding)
    belongs_to :regarding, inverse_of: :events, polymorphic: true
  end
end
