class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations, id: :uuid do |t|
      t.belongs_to :space, type: :uuid
      t.string :name, null: false
      t.string :email, null: false
      t.string :status, default: "pending", null: false
      t.datetime :last_sent_at
      t.timestamps
    end
  end
end
