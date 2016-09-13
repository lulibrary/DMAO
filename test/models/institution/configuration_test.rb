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
    refute @configuration.valid?
  end

  test 'should have no versions stored when not changed' do

    assert_empty @configuration.versions

  end

  test 'should add a version when changes are stored' do

    @configuration.systems_configuration = { cris_system: { id: 12345 } }

    assert @configuration.save

    assert_not_empty @configuration.versions

  end

end
