class CreateInstitutionOrganisationUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_organisation_units, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :system_uuid
      t.timestamp :system_modified_at
      t.string :isni
      t.string :unit_type

      t.timestamps

      t.references :institution
      t.uuid :parent_id, index: true

    end
  end
end
