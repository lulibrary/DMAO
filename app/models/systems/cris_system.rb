class Systems::CrisSystem < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true
  validates :version, presence: true, numericality: true

end
