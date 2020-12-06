class AddUniqIdxToPersonEmail < ActiveRecord::Migration[6.0]
  def change
    change_column :people, :email, :string, null: false
    add_index :people, :email, unique: true
  end
end
