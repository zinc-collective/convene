class RemoveJitsiPlaidUtilities < ActiveRecord::Migration[7.0]
  def up
    UtilityHookup.where(utility_slug: ["plaid", "jitsi"]).destroy_all
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
