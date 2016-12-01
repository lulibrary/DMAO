class DropInstitutionConfigurationsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :institution_configurations do |t|
      t.json :systems_configuration
      t.references :institution

      t.timestamps
    end
  end
end
