class AddBrandAttributesToSpace < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :spaces, bulk: true do |table|
        table.column :show_header, :boolean, null: false, default: false
        table.column :header_bg_color, :string, null: true
        table.column :header_txt_color, :string, null: true
      end
    end
  end
end
