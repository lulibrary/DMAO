require 'test_helper'

class Institution::ConfigurationTest < ActiveSupport::TestCase

  def setup
    @configuration = institution_configurations(:one)
  end

  test 'is valid' do
    assert @configuration.valid?
  end

  test 'systems configuration is required' do
    @configuration.systems_configuration = nil
    ::Configuration::SystemConfiguration.any_instance.expects(:valid?).returns false
    refute @configuration.valid?
  end

  test 'should have no versions stored when not changed' do

    assert_empty @configuration.versions

  end

  test 'should add a version when changes are stored' do

    @configuration.systems_configuration = { cris_system: { system_id: 321, config_values: [1,2,3,4,5] } }

    assert @configuration.save

    assert_not_empty @configuration.versions

  end

  test 'should call system configuration new when passing empty hash to set systems configuration' do

    new_system_config = ::Configuration::SystemConfiguration.new

    ::Configuration::SystemConfiguration.expects(:new).with({}).times(1).returns new_system_config

    @configuration.systems_configuration = {}

  end

  test 'should not call system configuration new when passed instance of system configuration' do

    new_system_config = ::Configuration::SystemConfiguration.new

    ::Configuration::SystemConfiguration.expects(:new).times(0)

    @configuration.systems_configuration = new_system_config


  end

  test 'should call to json on systems configuration when setting the internal configuration value' do

    new_system_config_json = ::Configuration::SystemConfiguration.new().to_json

    ::Configuration::SystemConfiguration.any_instance.expects(:to_json).times(1).returns(new_system_config_json)

    @configuration.systems_configuration = {}

  end

  test 'should create new instance when systems configuration is nil' do

    configuration = Institution::Configuration.new

    new_config = ::Configuration::SystemConfiguration.new

    ::Configuration::SystemConfiguration.expects(:new).times(1).returns(new_config)

    assert_instance_of ::Configuration::SystemConfiguration, configuration.systems_configuration

  end

  test 'should create new instance when system configuration is set to json' do

    new_config = ::Configuration::SystemConfiguration.new

    @configuration.systems_configuration = new_config

    ::Configuration::SystemConfiguration.expects(:new).times(1).returns(new_config)

    assert_instance_of ::Configuration::SystemConfiguration, @configuration.systems_configuration

  end

  test 'raw systems configuration should return raw json' do

    assert_instance_of String, @configuration.raw_systems_configuration

    assert JSON.parse(@configuration.raw_systems_configuration)

  end

end
