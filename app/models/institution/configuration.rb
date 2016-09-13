class Institution::Configuration < ApplicationRecord

  has_paper_trail

  validates :systems_configuration, presence: true

  belongs_to :institution

end
