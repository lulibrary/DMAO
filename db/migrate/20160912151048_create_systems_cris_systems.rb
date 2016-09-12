class CreateSystemsCrisSystems < ActiveRecord::Migration[5.0]
  def change
    create_table :systems_cris_systems do |t|
      t.string :name
      t.text :description
      t.integer :version

      t.timestamps
    end
  end
end
