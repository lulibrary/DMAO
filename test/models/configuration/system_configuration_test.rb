require 'test_helper'

module Configuration
  class SystemConfigurationTest < ActiveSupport::TestCase

    def setup

      @system_configuration = SystemConfiguration.new ( { cris_system: System::CrisSystem.new } )

    end

    test 'is a valid system configuration' do
      assert @system_configuration.valid?
    end

    test 'should be invalid without cris system' do
      @system_configuration.cris_system = nil
      refute @system_configuration.valid?
    end

    test 'should set cris system to be a new cris system' do

      Configuration::System::CrisSystem.expects(:new).times(1).returns(@system_configuration.cris_system)

      system_configuration = SystemConfiguration.new ( { cris_system: { system_id: 12345, config_values: [1,2,3,4,5] } } )

      assert system_configuration.valid?

    end

  end
end