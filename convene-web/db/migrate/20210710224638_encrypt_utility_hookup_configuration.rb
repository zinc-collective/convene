class EncryptUtilityHookupConfiguration < ActiveRecord::Migration[6.1]
  def change
    rename_column :utility_hookups, :configuration, :old_configuration
    add_column :utility_hookups, :configuration_ciphertext, :text

    reversible do |direction|
      direction.up do
        UtilityHookup.all.includes(:space).each do |uh|
          uh.update(configuration: uh.old_configuration)
        end
      end

      direction.down do
        UtilityHookup.all.includes(:space).each do |uh|
          uh.update(old_configuration: uh.configuration)
        end
      end
    end

    remove_column :utility_hookups, :old_configuration, :jsonb
  end
end
