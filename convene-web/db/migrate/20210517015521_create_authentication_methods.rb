class CreateAuthenticationMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :authentication_methods, id: :uuid do |t|
      t.belongs_to :person, type: :uuid

      t.string :method, null: false
      t.string :value, null: false
      t.datetime :confirmed_at

      t.text :one_time_password_secret_ciphertext
      t.string :encrypted_one_time_password_secret_iv
      t.datetime :last_one_time_password_at

      t.timestamps
      t.index [:method, :value], unique: true
    end
  end
end
