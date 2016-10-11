class Service::ApiToken < ApplicationRecord

  before_create :set_api_token
  before_validation :set_api_token
  validates :token, presence: true, uniqueness: true
  validates :service_name, presence: true

  private
  def set_api_token
    return if token.present?
    self.token = generate_api_token
  end

  def generate_api_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

end
