class Institution::OrganisationUnit < ApplicationRecord

  belongs_to :institution
  belongs_to :parent, class_name: 'Institution::OrganisationUnit'

  validates :name, presence: true
  validates :system_uuid, presence: true, uniqueness: { scope: :institution, message: "should be unique to the institution" }
  validates :system_modified_at, presence: true
  validates :unit_type, presence: true

end
