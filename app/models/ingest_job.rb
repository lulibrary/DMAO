class IngestJob < ApplicationRecord

  validates :ingest_type, presence: true, inclusion: %w{ingest refresh}
  validates :ingest_mode, presence: true, inclusion: %w{automatic manual}
  validates :ingest_area, presence: true, inclusion: %w{organisation}
  validates :institution, presence: true
  validates :status, presence: true

  belongs_to :institution

  mount_uploader :ingest_log_file, IngestLogFileUploader
  mount_uploader :ingest_data_file, IngestDataFileUploader

end
