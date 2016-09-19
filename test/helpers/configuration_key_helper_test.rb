require 'test_helper'

class ConfigurationKeyHelperTest < ActionView::TestCase

  def setup

    @configuration_key = systems_configuration_keys(:one)

  end

  test 'should return nil for invalid configuration key id when requesting name' do

    @configuration_key.id = 0

    assert_nil configuration_key_id_name @configuration_key.id

  end

  test 'should return nil for invalid configuration key id when requesting slug' do

    @configuration_key.id = 0

    assert_nil configuration_key_id_slug @configuration_key.id

  end

  test 'should return nil for invalid configuration key when requesting secure' do

    @configuration_key.id = 0

    assert_nil configuration_key_id_slug @configuration_key.id

  end

  test 'should return configuration key display name when requesting name' do

    assert_equal @configuration_key.display_name, configuration_key_id_name(@configuration_key.id)

  end

  test 'should return configuration key name when requesting slug' do

    assert_equal @configuration_key.name, configuration_key_id_slug(@configuration_key.id)

  end

  test 'should return configuration key secure when requesting secure' do

    assert_equal @configuration_key.secure, configuration_key_id_secure(@configuration_key.id)

  end

end