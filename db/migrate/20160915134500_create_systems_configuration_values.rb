class CreateSystemsConfigurationValues < ActiveRecord::Migration[5.0]
  def change
    create_table :systems_configuration_values do |t|
      t.string :encrypted_value
      t.references :institution, foreign_key: true
      t.references :systems_configuration_key, foreign_key: true, index: { name: 'index_configuration_values_on_configuration_key_id' }

      t.timestamps
    end
  end
end
