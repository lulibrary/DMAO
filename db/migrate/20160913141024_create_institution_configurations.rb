class CreateInstitutionConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_configurations do |t|
      t.json :systems_configuration
      t.references :institution

      t.timestamps
    end
  end
end
