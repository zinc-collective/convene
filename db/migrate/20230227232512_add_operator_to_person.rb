class AddOperatorToPerson < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :operator, :boolean, default: false
  end
end
