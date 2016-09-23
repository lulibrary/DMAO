require 'test_helper'

module DMAO
  module Logging

    class FakeTestClass

      include LogIngestErrors

    end

    class LogIngestErrorsTest < ActiveSupport::TestCase

      def setup

        @test_class = FakeTestClass.new

      end

      test 'should define create, close and log errors method' do

        assert_respond_to @test_class, :create_logger
        assert_respond_to @test_class, :log_ingest_error
        assert_respond_to @test_class, :close_log_file

      end

      test 'create should set logged errors to false' do

        assert_nil @test_class.logged_errors

        @test_class.create_logger "test_log_file"

        assert_not @test_class.logged_errors

      end

      test 'should create new ingest logger with filename' do

        DMAO::Ingesters::IngestLogger.expects(:new).once.with("test_log_file")

        @test_class.create_logger "test_log_file"

      end

      test 'should call close on logger' do

        DMAO::Ingesters::IngestLogger.any_instance.expects(:close).once

        @test_class.create_logger "test_log_file"

        @test_class.close_log_file

      end

      test 'log ingest errors should set logged errors to true' do

        @test_class.create_logger "test_log_file"

        assert_not @test_class.logged_errors

        @test_class.log_ingest_error "system uuid", "error message"

        assert @test_class.logged_errors

      end

      test 'logger should log error with system uuid and error message with empty hash when no errors passed in' do

        @test_class.create_logger "test_log_file"

        DMAO::Ingesters::IngestLogger.any_instance.expects(:error).once.with("system_uuid - error message - {}")

        @test_class.log_ingest_error "system_uuid", "error message"

      end

      test 'logger should log error with system uuid, error message and errors hash when passed in' do

        @test_class.create_logger "test_log_file"

        DMAO::Ingesters::IngestLogger.any_instance.expects(:error).once.with("system_uuid - error message - #{{errors_1: 'testing'}.to_json}")

        @test_class.log_ingest_error "system_uuid", "error message", { errors_1: "testing" }

      end

    end

  end
end