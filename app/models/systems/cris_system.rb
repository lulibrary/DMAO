class Systems::CrisSystem < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true
  validates :version, presence: true, numericality: true

  has_many :configuration_keys, :class_name => 'Systems::ConfigurationKey', as: :systemable

end
