class SproutInitialDomainModel < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :people, id: :uuid do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    create_table :workspace_memberships, id: :uuid do |t|
      t.belongs_to :member, type: :uuid
      t.belongs_to :workspace, type: :uuid
      t.string :access_code
    end

    create_table :rooms, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.string :access_level
      t.string :access_code
      t.string :publicity_level
      t.timestamps
      t.belongs_to :workspace, type: :uuid
      t.index %i[slug workspace_id], unique: true
    end

    create_table :room_ownerships, id: :uuid do |t|
      t.belongs_to :owner, type: :uuid
      t.belongs_to :room, type: :uuid
    end

    create_table :clients, id: :uuid do |t|
      t.string :name
      t.string :slug, unique: true
      t.timestamps
    end

    create_table :workspaces, id: :uuid do |t|
      t.belongs_to :client, type: :uuid
      t.string :jitsi_meet_domain
      t.string :name
      t.string :access_level
      t.string :access_code
      t.string :slug, unique: true
      t.index %i[slug client_id], unique: true
      t.timestamps
    end
  end
end
