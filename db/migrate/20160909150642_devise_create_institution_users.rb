class DeviseCreateInstitutionUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.string :name
      t.references :institution

      t.timestamps null: false
    end

    add_index :institution_users, :email,                unique: true
    add_index :institution_users, :reset_password_token, unique: true
    add_index :institution_users, :unlock_token,         unique: true
  end
end
