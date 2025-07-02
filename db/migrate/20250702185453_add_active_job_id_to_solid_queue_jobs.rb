class AddActiveJobIdToSolidQueueJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :solid_queue_jobs, :active_job_id, :uuid
    add_index :solid_queue_jobs, :active_job_id
  end
end