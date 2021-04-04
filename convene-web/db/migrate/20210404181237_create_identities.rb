class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities, id: :uuid do |t|
      t.column     :name,    :string
      t.column     :pronoun, :string
      t.belongs_to :person,  foreign_key: true, type: :uuid
      t.belongs_to :space,   foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index(
      :identities,
      [:person_id, :space_id],
      unique: true,
    )
  end
end
