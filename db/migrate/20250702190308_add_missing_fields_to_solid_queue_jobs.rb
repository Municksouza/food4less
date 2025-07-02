class AddMissingFieldsToSolidQueueJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :solid_queue_jobs, :class_name, :string

    add_index :solid_queue_jobs, :class_name
  end
end