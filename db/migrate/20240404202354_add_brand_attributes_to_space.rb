class AddBrandAttributesToSpace < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :spaces, bulk: true do |table|
        table.column :brand_header, :boolean, null: false, default: false
        table.column :brand_color, :string, null: true
      end
    end
  end
end
