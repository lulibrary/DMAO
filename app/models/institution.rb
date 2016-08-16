class Institution < ApplicationRecord

  validates :identifier, presence: true, uniqueness: true
  validates :name, presence: true

end
