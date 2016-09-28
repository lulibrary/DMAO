class AddIngestDataFileToIngestJob < ActiveRecord::Migration[5.0]
  def change
    add_column :ingest_jobs, :ingest_data_file, :string
  end
end
