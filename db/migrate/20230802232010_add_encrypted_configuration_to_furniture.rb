class AddEncryptedConfigurationToFurniture < ActiveRecord::Migration[7.0]
  def change
    add_column :furnitures, :configuration_ciphertext, :text
  end
end
