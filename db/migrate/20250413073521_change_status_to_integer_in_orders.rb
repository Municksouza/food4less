class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[7.0]  
  def up
    # Only proceed if status column is still string
    if column_exists?(:orders, :status, :string)
      add_column :orders, :status_tmp, :integer
  
      execute <<-SQL
        UPDATE orders SET status_tmp = CASE
          WHEN status = 'pending' THEN 0
          WHEN status = 'accepted' THEN 1
          WHEN status = 'rejected' THEN 2
          WHEN status = 'approved' THEN 3
          WHEN status = 'completed' THEN 4
          ELSE 0
        END
      SQL
  
      remove_column :orders, :status, :string
      rename_column :orders, :status_tmp, :status
    else
      puts "⚠️ Status column already converted to integer. Skipping migration logic."
    end
  end

  def down
    add_column :orders, :status_tmp, :string

    execute <<-SQL
      UPDATE orders SET status_tmp = CASE
        WHEN status = 0 THEN 'pending'
        WHEN status = 1 THEN 'accepted'
        WHEN status = 2 THEN 'rejected'
        WHEN status = 3 THEN 'approved'
        WHEN status = 4 THEN 'completed'
        ELSE 'pending'
      END
    SQL

    remove_column :orders, :status, :integer
    rename_column :orders, :status_tmp, :status
  end
end