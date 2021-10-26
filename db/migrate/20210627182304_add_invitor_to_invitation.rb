class AddInvitorToInvitation < ActiveRecord::Migration[6.1]
  def change
    change_table :invitations do |t|
      t.references :invitor, type: :uuid
    end
  end
end
