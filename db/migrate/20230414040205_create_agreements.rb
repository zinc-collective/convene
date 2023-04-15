class CreateAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :space_agreements, id: :uuid do |t|
      t.belongs_to :space, type: :uuid, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.index [:space_id, :slug], unique: true
      t.index [:space_id, :name], unique: true
      t.timestamps
    end
  end
end
