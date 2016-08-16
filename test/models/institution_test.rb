require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase

  def setup
    @institution = institutions(:luve)
  end

  test 'is valid' do
    assert @institution.valid?
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

  test 'allows a single string with numbers for institution identifier' do
    @institution.identifier = 'abcd1234'
    assert @institution.valid?
  end

  test 'does not allow spaces or non alpha numeric characters in institution identifier' do
    @institution.identifier = 'abcd 1234'
    refute @institution.valid?
  end

  test 'allows a dash within the institution identifier' do
    @institution.identifier = 'abcd-1234'
    assert @institution.valid?
  end

  test 'is valid with a valid email' do
    @institution.contact_email = "admin@example.com"
    assert @institution.valid?
  end

  test 'is invalid with non valid email' do
    @institution.contact_email = "testing"
    refute @institution.valid?
  end

end
