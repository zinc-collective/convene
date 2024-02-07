class CreateMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :media, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.timestamps
    end
  end
end
