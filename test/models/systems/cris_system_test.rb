require 'test_helper'

class Systems::CrisSystemTest < ActiveSupport::TestCase

  def setup
    @cris_system = systems_cris_systems(:one)
  end

  test 'Is a valid cris system?' do
    assert @cris_system.valid?
  end

  test 'Should be invalid without a name' do
    @cris_system.name = nil
    refute @cris_system.valid?
  end

  test 'Should be invalid without a description' do
    @cris_system.description = nil
    refute @cris_system.valid?
  end

  test 'Should be invalid without a version' do
    @cris_system.version = nil
    refute @cris_system.valid?
  end

  test 'Should be invalid for version being text' do
    @cris_system.version = "V1"
    refute @cris_system.valid?
  end

  test 'Should be invalid without organisation ingester' do
    @cris_system.organisation_ingester = nil
    refute @cris_system.valid?
  end

  test 'Should set systemable type to "Systems::CrisSystem" when adding configuration key' do

    config_key = @cris_system.configuration_keys.new

    assert "Systems::CrisSystem", config_key.systemable_type

  end

  test 'Should set systemable id to that of cris system when adding configuration key' do

    config_key = @cris_system.configuration_keys.new

    assert @cris_system.id, config_key.systemable_id

  end

end
