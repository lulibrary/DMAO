class CreateServiceApiTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :service_api_tokens do |t|
      t.string :service_name
      t.string :token

      t.timestamps
    end
    add_index :service_api_tokens, :token, :unique => true
  end
end
