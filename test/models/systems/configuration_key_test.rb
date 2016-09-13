require 'test_helper'

class Systems::ConfigurationKeyTest < ActiveSupport::TestCase

  def setup
    @configuration_key = systems_configuration_keys(:one)
    @configuration_key_2 = systems_configuration_keys(:two)
  end

  test 'Is a valid configuration key' do
    assert @configuration_key.valid?
  end

  test 'Should be invalid without a name' do
    @configuration_key.name = nil
    refute @configuration_key.valid?
  end

  test 'Should be invalid without a display name' do
    @configuration_key.display_name = nil
    refute @configuration_key.valid?
  end

  test 'name should be invalid if it has spaces' do
    @configuration_key.name = "testing name"
    refute @configuration_key.valid?
  end

  test 'name should be valid if it is alphanumeric or has a dash/underscore' do

    @configuration_key.name = "testing"
    assert @configuration_key.valid?

    @configuration_key.name = "testing_name"
    assert @configuration_key.valid?

    @configuration_key.name = "testing-name"
    assert @configuration_key.valid?

    @configuration_key.name = "testing1234"
    assert @configuration_key.valid?

  end

  test 'configuration key name should be unique on system' do

    duplicate_configuration_key = @configuration_key.dup

    refute duplicate_configuration_key.valid?

  end

  test 'same configuration key name should be allowed on different systems of the same type' do

    @configuration_key_2.name = @configuration_key.name

    assert @configuration_key.valid?
    assert @configuration_key_2.valid?

  end

end
