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

end
