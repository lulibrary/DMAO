require 'test_helper'

class Institution::OrganisationUnitTest < ActiveSupport::TestCase

  def setup
    @organisation_unit = institution_organisation_units(:one)
    @organisation_unit_2 = institution_organisation_units(:two)
  end

  test 'Is a valid institution organisation unit' do
    assert @organisation_unit.valid?
  end

  test 'Should be invalid without name' do
    @organisation_unit.name = nil
    refute @organisation_unit.valid?
  end

  test 'Should be invalid without system uuid' do
    @organisation_unit.system_uuid = nil
    refute @organisation_unit.valid?
  end

  test 'Should be invalid without system modified at timestamp' do
    @organisation_unit.system_modified_at = nil
    refute @organisation_unit.valid?
  end

  test 'Should be invalid without type' do
    @organisation_unit.unit_type = nil
    refute @organisation_unit.valid?
  end

  test 'Should be invalid to have 2 organisation units in the same institution with same system uuid' do
    @organisation_unit_2.system_uuid = @organisation_unit.system_uuid
    refute @organisation_unit_2.valid?
  end

  test 'Parent of organisation unit should be an organisation unit' do
    assert_instance_of Institution::OrganisationUnit, @organisation_unit_2.parent
  end

end
