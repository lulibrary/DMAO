module DMAO
  module Ingesters

    class IngestLogger < Logger

      attr_reader :log_file_path

      def initialize ingest=nil

        if ingest.nil?
          ingest = "new_ingest"
        end

        directory = Rails.application.config_for(:dmao)["ingest_log"]["directory"]

        @log_file_path = "#{directory}/#{ingest}_#{Time.now.to_i}.log"

        super(log_file_path)

        self.formatter = formatter

        self

      end

      def formatter

        Proc.new{|severity, time, progname, msg|
          formatted_severity = sprintf("%-5s", severity.to_s)
          formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
          "[#{formatted_severity} #{formatted_time}] #{msg.to_s.strip}\n"
        }

      end

    end

  end
end