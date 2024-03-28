class CreateTextBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :text_blocks, id: :uuid do |t|
      t.timestamps
    end
  end
end
