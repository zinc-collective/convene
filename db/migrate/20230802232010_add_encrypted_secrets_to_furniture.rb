class AddEncryptedSecretsToFurniture < ActiveRecord::Migration[7.0]
  def change
    add_column :furnitures, :secrets_ciphertext, :text
  end
end
