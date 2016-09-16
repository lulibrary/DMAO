require 'test_helper'

class CreateSystemsConfigurationTest < ActiveSupport::TestCase

  def setup

    @institution = institutions(:test)

    @configuration_hash = configuration_hash

  end

  test 'when initialised should accept institution and configuration hash parameters' do

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    assert_instance_of CreateSystemsConfiguration, create_system_configuration

  end

  test 'should call new on system configuration with configuration hash' do

    new_system_config = Configuration::SystemConfiguration.new

    Configuration::SystemConfiguration.expects(:new).once.with(@configuration_hash).returns(new_system_config)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    create_system_configuration.call

  end

  test 'should return system configuration with errors if cris system configuration is invalid' do

    Configuration::System::CrisSystem.any_instance.expects(:valid?).once.returns(false)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

    assert_includes response.errors, :cris_system

  end

  test 'should return error if cris system cannot be found for cris system id' do

    Systems::CrisSystem.expects(:find).once.raises(ActiveRecord::RecordNotFound)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

    assert_includes response.errors, :cris_system

  end

  test 'should return error if config key value is for an invalid config key id' do

    i = 0
    config_key_values = {}

    @configuration_hash[:cris_system][:configuration_key_values].each do |k, v|

      config_key_values[i] = v

      i += 1

    end

    @configuration_hash[:cris_system][:configuration_key_values] = config_key_values

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

    assert_includes response.errors, :cris_system

    assert_includes response.errors[:cris_system], "Invalid configuration keys for choosen CRIS System specified."

  end

  test 'if systems configuration has errors should return with errors' do

    Configuration::SystemConfiguration.any_instance.expects(:errors).at_least_once.returns(fake_errors_object)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

  end

  test 'should call create on system configuration value for number of keys existing in configuration hash' do

    number_of_config_keys = @configuration_hash[:cris_system][:configuration_key_values].length

    created_config_value = Systems::ConfigurationValue.new(institution: @institution, value: "Testing")

    Systems::ConfigurationValue.expects(:create).times(number_of_config_keys).returns(created_config_value)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

    assert_not response.errors.any?

  end

  test 'should increase configuration value config for number of keys specified' do

    number_of_config_keys = @configuration_hash[:cris_system][:configuration_key_values].length

    assert_difference "Systems::ConfigurationValue.count", number_of_config_keys do

      create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

      response = create_system_configuration.call

    end

  end

  test 'should call add config value for cris system with id of stored config value' do

    number_of_config_keys = @configuration_hash[:cris_system][:configuration_key_values].length

    created_config_value = Systems::ConfigurationValue.new(institution: @institution, value: "Testing", id: 1234)

    Systems::ConfigurationValue.expects(:create).times(number_of_config_keys).returns(created_config_value)

    Configuration::System::CrisSystem.any_instance.expects(:add_config_value).times(number_of_config_keys).with(created_config_value.id)

    create_system_configuration = CreateSystemsConfiguration.new(@institution, @configuration_hash)

    response = create_system_configuration.call

    assert_instance_of Configuration::SystemConfiguration, response

    assert_instance_of ActiveModel::Errors, response.errors

    assert_not response.errors.any?

  end

  private

  def configuration_hash

    cris_system = systems_cris_systems(:one)

    config_key_ids = cris_system.configuration_keys.ids

    config_values = {}

    config_key_ids.each { |id| config_values[id.to_s] = { value: "testing key #{id} value" } }

    {
      cris_system: {
        system_id: cris_system.id,
        configuration_key_values: config_values
      }
    }

  end

  def fake_errors_object

    errors = ActiveModel::Errors.new(self)

    errors.add(:testing, "TESTING ERROR")

    errors

  end

end