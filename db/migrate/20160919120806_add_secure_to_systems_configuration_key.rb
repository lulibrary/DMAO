class AddSecureToSystemsConfigurationKey < ActiveRecord::Migration[5.0]
  def change
    add_column :systems_configuration_keys, :secure, :boolean
  end
end
