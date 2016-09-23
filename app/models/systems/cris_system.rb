class Systems::CrisSystem < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true
  validates :version, presence: true, numericality: true
  validates :organisation_ingester, presence: true

  has_many :configuration_keys, :class_name => 'Systems::ConfigurationKey', as: :systemable, inverse_of: :systemable

  accepts_nested_attributes_for :configuration_keys

end
