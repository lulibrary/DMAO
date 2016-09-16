class Institution::Configuration < ApplicationRecord

  has_paper_trail

  validates :systems_configuration, presence: true
  validate :valid_system_configuration

  belongs_to :institution

  def systems_configuration=(value)

    if value.is_a?(::Configuration::SystemConfiguration)
      systems_config = value
    else
      systems_config = ::Configuration::SystemConfiguration.new value
    end

    super(systems_config.to_json(except: ["errors", :errors]))

  end

  def systems_configuration

    if self[:systems_configuration].nil?
      return ::Configuration::SystemConfiguration.new
    end

    if self[:systems_configuration].is_a?(::Configuration::SystemConfiguration)
      return self[:systems_configuration]
    end

    @systems_configuration = ::Configuration::SystemConfiguration.new JSON.parse(self[:systems_configuration])

  end

  def raw_systems_configuration
    self[:systems_configuration]
  end

  private

  def valid_system_configuration
    errors.add(:systems_configuration, self.systems_configuration.errors) unless self.systems_configuration.valid?
  end

end
