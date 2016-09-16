require 'test_helper'

module Configuration
  module System
    class CrisSystemTest < ActiveSupport::TestCase

      def setup

        @cris_system = CrisSystem.new({ system_id: 12345, config_values: [1,2,3,4,5] })

      end

      test 'is a valid cris system configuration' do
        assert @cris_system.valid?
      end

      test 'Should be invalid without system id' do
        @cris_system.system_id = nil
        refute @cris_system.valid?
      end

      test 'Should be invalid if config values is not an array' do
        @cris_system.config_values = "STRING"
        refute @cris_system.valid?
      end

      test 'config values should be set to an empty array if attribute is nil on initialise' do

        hash = { system_id: 12345, config_values: nil }

        cris_system = CrisSystem.new hash

        assert_instance_of Array, cris_system.config_values

      end

      test 'config values should be set to an empty array if attribute is empty on initialise' do

        hash = { system_id: 12345, config_values: "" }

        cris_system = CrisSystem.new hash

        assert_instance_of Array, cris_system.config_values

      end

      test 'config values should be set to an empty array if attribute is not an array on initialise' do

        hash = { system_id: 12345, config_values: {testing: 1234} }

        cris_system = CrisSystem.new hash

        assert_instance_of Array, cris_system.config_values

      end

      test 'add config value should add specified id to config values' do

        assert_difference "@cris_system.config_values.length" do
          @cris_system.add_config_value 123
        end

      end

      test 'remove config value should remove specified id from config values' do

        assert_difference "@cris_system.config_values.length", -1 do
          @cris_system.remove_config_value 1
        end

        assert_not_includes @cris_system.config_values, 1

      end

    end
  end
end