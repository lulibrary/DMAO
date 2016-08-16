class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :identifier
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone_number
      t.string :locale
      t.string :url
      t.text :description

      t.timestamps
    end
    add_index :institutions, :identifier, :unique => true
  end
end
