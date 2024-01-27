class Tobias
  class Beneficiary < Record
    self.table_name = "tobias_beneficiaries"

    belongs_to :trust

    has_many :payments
  end
end
