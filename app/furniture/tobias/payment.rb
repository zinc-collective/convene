class Tobias
  class Payment < ApplicationRecord
    self.table_name = "tobias_payments"

    monetize :amount_cents
  end
end
