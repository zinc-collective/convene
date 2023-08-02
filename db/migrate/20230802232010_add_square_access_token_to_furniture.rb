class AddSquareAccessTokenToFurniture < ActiveRecord::Migration[7.0]
  def change
    add_column :furnitures, :square_access_token_ciphertext, :text
  end
end
