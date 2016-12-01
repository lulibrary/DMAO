class DropSystemsCrisSystemsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :systems_cris_systems do |t|
      t.string :name
      t.text :description
      t.integer :version
      t.string :organisation_ingester

      t.timestamps
    end
  end
end
