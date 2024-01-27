class Tobias
  class Payment < Record
    self.table_name = "tobias_payments"

    monetize :amount_cents
  end
end
