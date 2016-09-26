require 'test_helper'

module DMAO
  class IngestersTest < ActiveSupport::TestCase

    test 'add new organisation ingester using register' do

      DMAO::Ingesters.register(:ingester_name, "INGESTER Name", 0.1, :organisation, String)

      details_hash = {
          name: :ingester_name,
          display_name: "INGESTER Name",
          version: 0.1,
          type: :organisation,
          ingester_type: nil
      }

      assert_equal 1, DMAO::Ingesters::ALL.select { |v| v == :ingester_name }.size
      assert_equal 1, DMAO::Ingesters::ORG_INGESTERS.select { |v| v == :ingester_name }.size
      assert_equal details_hash, DMAO::Ingesters::DETAILS[:ingester_name]
      assert_equal String, DMAO::Ingesters::ORG_INGESTERS[:ingester_name]

      DMAO::Ingesters::ALL.delete(:ingester_name)
      DMAO::Ingesters::DETAILS.delete(:ingester_name)
      DMAO::Ingesters::ORG_INGESTERS.delete(:ingester_name)

    end

    test 'add new ingester with generic type using register' do

      DMAO::Ingesters.register(:ingester_name, "INGESTER Name", 0.1, :testing, String)

      details_hash = {
          name: :ingester_name,
          display_name: "INGESTER Name",
          version: 0.1,
          type: :testing,
          ingester_type: nil
      }

      assert_equal 1, DMAO::Ingesters::ALL.select { |v| v == :ingester_name }.size
      assert_equal 0, DMAO::Ingesters::ORG_INGESTERS.select { |v| v == :ingester_name }.size
      assert_equal details_hash, DMAO::Ingesters::DETAILS[:ingester_name]

      DMAO::Ingesters::ALL.delete(:ingester_name)
      DMAO::Ingesters::DETAILS.delete(:ingester_name)

    end

    test 'add new ingester with organisation type and ingester type as file' do

      DMAO::Ingesters.register(:ingester_name, "INGESTER Name", 0.1, :organisation, String, :file)

      details_hash = {
          name: :ingester_name,
          display_name: "INGESTER Name",
          version: 0.1,
          type: :organisation,
          ingester_type: :file
      }

      assert_equal 1, DMAO::Ingesters::ALL.select { |v| v == :ingester_name }.size
      assert_equal 1, DMAO::Ingesters::ORG_INGESTERS.select { |v| v == :ingester_name }.size
      assert_equal details_hash, DMAO::Ingesters::DETAILS[:ingester_name]
      assert_equal 1, DMAO::Ingesters::FILE_INGESTERS.select { |v| v == :ingester_name }.size

      DMAO::Ingesters::ALL.delete(:ingester_name)
      DMAO::Ingesters::DETAILS.delete(:ingester_name)
      DMAO::Ingesters::ORG_INGESTERS.delete(:ingester_name)
      DMAO::Ingesters::FILE_INGESTERS.delete(:ingester_name)

    end

    test 'should raise invalid ingester type if not in the valid array' do

      assert_raises DMAO::Ingesters::Errors::InvalidIngesterType do
        DMAO::Ingesters.register(:ingester_name, "INGESTER Name", 0.1, :organisation, String, :invalid)
      end

      DMAO::Ingesters::ALL.delete(:ingester_name)
      DMAO::Ingesters::DETAILS.delete(:ingester_name)
      DMAO::Ingesters::ORG_INGESTERS.delete(:ingester_name)
      DMAO::Ingesters::FILE_INGESTERS.delete(:ingester_name)

    end

  end
end