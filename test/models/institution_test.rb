require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase

  def setup
    @institution = institutions(:luve)
  end

  test 'is valid' do
    @institution.valid?
  end

  test 'identifier is required' do
    @institution.identifier = nil
    refute @institution.valid?
  end

  test 'name is required' do
    @institution.name = nil
    refute @institution.valid?
  end

  test 'does not allow a duplicate institution identifier' do

    duplicate_institution = @institution.dup

    refute duplicate_institution.valid?

  end

end
