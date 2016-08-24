class DmaoAdmin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :lockable
end
