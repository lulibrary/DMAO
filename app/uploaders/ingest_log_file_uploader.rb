# encoding: utf-8

class IngestLogFileUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "ingest_logs/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(log)
  end

end
