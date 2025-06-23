class CreateSolidQueueJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :solid_queue_jobs do |t|
      t.string     :queue_name, null: false
      t.string     :job_class, null: false
      t.text       :arguments
      t.timestamp  :scheduled_at
      t.timestamp  :finished_at
      t.timestamp  :started_at
      t.string     :status, null: false, default: "enqueued"
      t.text       :error
      t.integer    :attempts, default: 0, null: false
      t.uuid       :active_job_id, index: true
      t.timestamps
    end

    add_index :solid_queue_jobs, :queue_name
    add_index :solid_queue_jobs, :status
    add_index :solid_queue_jobs, :scheduled_at
  end
end