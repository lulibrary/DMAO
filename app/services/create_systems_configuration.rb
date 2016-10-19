class CreateSystemsConfiguration

  def initialize institution, configuration_hash
    @institution = institution
    @configuration_hash = configuration_hash
  end


  def call

    # create system config object with cris system config

    systems_configuration = ::Configuration::SystemConfiguration.new @configuration_hash

    if !systems_configuration.cris_system.valid?
      systems_configuration.errors.add(:cris_system, systems_configuration.cris_system.errors)
      return systems_configuration
    end

    config_key_values = @configuration_hash[:cris_system][:configuration_key_values]

    # get cris system

    begin

      cris_system = ::Systems::CrisSystem.find(systems_configuration.cris_system.system_id)

    rescue ActiveRecord::RecordNotFound

      systems_configuration.errors.add(:cris_system, "Invalid system id")

      return systems_configuration

    end

    config_key_ids = cris_system.configuration_keys.ids

    # check configurations key values are set for all config keys else errors

    if config_key_values.present?

      config_key_values.keys.each do |k|

        if !config_key_ids.include?(k.to_i)

          config_key_values.delete(k)

          systems_configuration.errors.add(:cris_system, "Invalid configuration keys for choosen CRIS System specified.")

        end

      end

    end

    return systems_configuration if systems_configuration.errors.any?

    # Store configuration key values

    if config_key_values.present?

      config_key_values.each_pair do |k, v|

        config_value = create_system_configuration_value k, v, @institution

        # set cris system configuration key

        systems_configuration.cris_system.add_config_value config_value.id

      end

    end

    systems_configuration

  end

  private

  def create_system_configuration_value config_key_id, value, institution

    key = ::Systems::ConfigurationKey.find(config_key_id.to_i)

    value = value.symbolize_keys

    ::Systems::ConfigurationValue.create(institution: institution, configuration_key: key, value: value[:value])

  end

end