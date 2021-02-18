class CreateSpaceHookups < ActiveRecord::Migration[6.1]
  def change
    create_table :space_hookups, id: :uuid do |t|
      t.belongs_to :space, type: :uuid

      t.string :name, null: false
      t.string :hookup_slug, null: false

      t.string :status, null: false, default: 'unavailable'

      t.jsonb :configuration

      t.timestamps
    end
  end
end
