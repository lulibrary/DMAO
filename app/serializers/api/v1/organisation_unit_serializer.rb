module API
  module V1

    class OrganisationUnitSerializer < ActiveModel::Serializer
      attributes :id, :name, :description, :url, :system_uuid, :system_modified_at, :isni, :unit_type

      has_one :parent, serializer: API::V1::OrganisationUnitSerializer

    end

  end
end


