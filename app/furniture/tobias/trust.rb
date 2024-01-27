class Tobias
  class Trust < ApplicationRecord
    self.table_name = "tobias_trusts"

    has_many :beneficiaries
  end
end
