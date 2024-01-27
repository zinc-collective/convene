class Tobias
  class Trust < Record
    self.table_name = "tobias_trusts"

    has_many :beneficiaries

  end
end
