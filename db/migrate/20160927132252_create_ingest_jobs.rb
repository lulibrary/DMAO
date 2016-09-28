class CreateIngestJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :ingest_jobs, id: :uuid do |t|
      t.timestamp :ingest_time
      t.string :status
      t.string :ingest_type
      t.string :ingest_mode
      t.string :ingest_area
      t.references :institution, foreign_key: true

      t.timestamps
    end
  end
end
