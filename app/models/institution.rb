class Institution < ApplicationRecord

  validates :identifier, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-]+\Z/ }
  validates :name, presence: true

end
