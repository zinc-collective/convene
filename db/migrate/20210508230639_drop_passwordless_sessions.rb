class DropPasswordlessSessions < ActiveRecord::Migration[6.1]
  def change
    drop_table :passwordless_sessions
  end
end
