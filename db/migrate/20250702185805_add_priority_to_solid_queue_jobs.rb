class AddPriorityToSolidQueueJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :solid_queue_jobs, :priority, :integer, default: 0, null: false
    add_index :solid_queue_jobs, :priority
  end
end