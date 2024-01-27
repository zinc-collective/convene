class Tobias
  class Beneficiary < ApplicationRecord
    self.table_name = "tobias_beneficiaries"

    belongs_to :trust

    has_many :payments
  end
end
