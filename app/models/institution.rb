class Institution < ApplicationRecord

  cattr_accessor :current_id

  validates :identifier, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-]+\Z/ }
  validates :name, presence: true
  validates :contact_email, email: true

  has_many :admins, class_name: 'Institution::Admin'
  has_many :users, class_name: 'Institution::User'

end
