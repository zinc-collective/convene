class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles, id: :uuid do |t|
      t.column     :name,    :string
      t.column     :pronoun, :string
      t.belongs_to :person,  foreign_key: true, type: :uuid
      t.belongs_to :space_membership, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index(
      :profiles,
      [:person_id, :space_membership_id],
      unique: true,
    )
  end
end
