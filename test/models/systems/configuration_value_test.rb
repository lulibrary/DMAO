require 'test_helper'

class Systems::ConfigurationValueTest < ActiveSupport::TestCase

  def setup

    @config_value = systems_configuration_values(:one)

  end

  test "is a valid configuration value" do

    assert @config_value.valid?

  end

  test 'is invalid without an institution' do

    @config_value.institution = nil

    refute @config_value.valid?

  end

  test 'is invalid without a configuration key' do

    @config_value.configuration_key = nil

    refute @config_value.valid?

  end

  test 'value should be stored encrypted' do

    @config_value.encrypted_value = "testing1234"

    refute @config_value.valid?

  end

end
