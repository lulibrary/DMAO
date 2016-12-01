class DropSystemsConfigurationKeysTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :systems_configuration_keys do |t|

      t.string :name
      t.string :display_name
      t.boolean :secure
      t.references :systemable, polymorphic: true, index: { name: 'index_systems_configuration_keys_on_systemable' }

      t.timestamps

    end
  end
end
