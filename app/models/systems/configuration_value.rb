class Systems::ConfigurationValue < ApplicationRecord

  attr_encrypted :value

  validates :institution, presence: true
  validates :configuration_key, presence: true

  validates :encrypted_value, presence: true, symmetric_encryption: true

  belongs_to :institution, :class_name => 'Institution'
  belongs_to :configuration_key, foreign_key: "systems_configuration_key_id", :class_name => 'Systems::ConfigurationKey'

end
