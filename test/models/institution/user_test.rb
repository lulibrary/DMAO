require 'test_helper'

class Institution::UserTest < ActiveSupport::TestCase

  def setup
    @institution_user = institution_users(:one)
  end

  test 'Is a valid institution user' do
    assert @institution_user.valid?
  end

  test 'should be invalid without name' do
    @institution_user.name = nil
    refute @institution_user.valid?
  end

  test 'should be invalid without institution' do
    @institution_user.institution = nil
    refute @institution_user.valid?
  end

end
