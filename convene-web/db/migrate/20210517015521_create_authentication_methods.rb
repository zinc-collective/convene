class CreateAuthenticationMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :authentication_methods, id: :uuid do |t|
      t.belongs_to :person, type: :uuid

      t.string :contact_method, null: false
      t.string :contact_location, null: false
      t.datetime :confirmed_at

      t.text :one_time_password_secret_ciphertext
      t.string :encrypted_one_time_password_secret_iv
      t.datetime :last_one_time_password_at

      t.timestamps
      t.index [:contact_method, :contact_location], unique: true,
              name: "index_authentication_methods_on_contact_fields"
    end
  end
end
