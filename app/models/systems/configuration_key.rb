class Systems::ConfigurationKey < ApplicationRecord

  validates :name,
            presence: true,
            format: { with: /\A[a-zA-Z0-9\-_]+\Z/ },
            uniqueness: { scope: :systemable }
  validates :display_name, presence: true

  belongs_to :systemable, polymorphic: true

  after_initialize :set_secure_default

  def set_secure_default

    self.secure ||= false

  end

end
