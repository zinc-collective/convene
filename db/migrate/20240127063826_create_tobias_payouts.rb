class CreateTobiasPayouts < ActiveRecord::Migration[7.1]
  def change
    create_table :tobias_trusts, id: :uuid do |t|
      t.timestamps
    end

    create_table :tobias_beneficiaries, id: :uuid do |t|
      t.references :trust, type: :uuid, foreign_key: {to_table: :tobias_trusts}

      t.timestamps
    end

    create_table :tobias_payouts, id: :uuid do |t|
      t.monetize :amount
      t.references :trust, type: :uuid, foreign_key: {to_table: :tobias_trusts}
      t.timestamps
    end

    create_table :tobias_payments, id: :uuid do |t|
      t.references :payout, type: :uuid, foreign_key: {to_table: :tobias_payouts}
      t.references :beneficiary, type: :uuid, foreign_key: {to_table: :tobias_beneficiaries}
      t.monetize :amount

      t.timestamps
    end
  end
end
