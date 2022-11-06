class AddTimestampsToSpaceMemberships < ActiveRecord::Migration[7.0]
  def change
    change_table :space_memberships do |t|
      t.timestamps default: Time.zone.now
    end

    up_only do
      execute <<~SQL.squish
        ALTER TABLE space_memberships
          ALTER COLUMN created_at DROP DEFAULT
        ;
        ALTER TABLE space_memberships
          ALTER COLUMN updated_at DROP DEFAULT
        ;
      SQL
    end
  end
end
