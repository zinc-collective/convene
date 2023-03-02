class DropClient < ActiveRecord::Migration[7.0]
  def change
    drop_table :clients
  end
end
