require 'test_helper'

class InstitutionAdminTest < ActiveSupport::TestCase

  def setup
    @institution_admin = institution_admins(:one)
  end

  test 'Is a valid institution admin?' do
    assert @institution_admin.valid?
  end

  test 'Should be invalid without name' do
    @institution_admin.name = nil
    refute @institution_admin.valid?
  end

  test 'Should be invalid without institution' do
    @institution_admin.institution = nil
    refute @institution_admin.valid?
  end

end
