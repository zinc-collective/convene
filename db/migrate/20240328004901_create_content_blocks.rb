class CreateContentBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :content_blocks, id: :uuid do |t|
      t.timestamps
    end
  end
end
