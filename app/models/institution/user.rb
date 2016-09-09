class Institution::User < ApplicationRecord

  devise :database_authenticatable, :recoverable, :trackable, :validatable, :lockable

  belongs_to :institution

  validates :name, presence: true
  validates :institution, presence: true

end
