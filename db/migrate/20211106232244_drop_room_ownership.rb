class DropRoomOwnership < ActiveRecord::Migration[6.1]
  def change
    drop_table :room_ownerships, id: :uuid do |t|
      t.belongs_to :owner, type: :uuid
      t.belongs_to :room, type: :uuid
    end
  end
end
