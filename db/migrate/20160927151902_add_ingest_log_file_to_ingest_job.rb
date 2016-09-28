class AddIngestLogFileToIngestJob < ActiveRecord::Migration[5.0]
  def change
    add_column :ingest_jobs, :ingest_log_file, :string
  end
end
