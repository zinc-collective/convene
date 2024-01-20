class AddHeroImageToRooms < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :rooms, :hero_image, null: true, type: :uuid, index: {algorithm: :concurrently}
  end
end
