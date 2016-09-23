class AddOrganisationIngesterToSystemsCrisSystem < ActiveRecord::Migration[5.0]
  def change
    add_column :systems_cris_systems, :organisation_ingester, :string
  end
end
