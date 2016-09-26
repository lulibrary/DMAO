module DMAO
  module Ingesters
    module Errors

      class InvalidIngesterType < StandardError

        def initialize(msg="Invalid ingester type specified valid ingester types are #{DMAO::Ingesters::VALID_INGESTER_TYPES}")

          super(msg)

        end

      end

    end
  end
end