module DMAO
  module Ingesters
    module Errors

      class UnknownIngester < StandardError

        def initialize(msg="Unknown ingest area, please check that this is a valid ingest area.")

          super(msg)

        end

      end

    end
  end
end