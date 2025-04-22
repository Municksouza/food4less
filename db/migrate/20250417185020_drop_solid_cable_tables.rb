class DropSolidCableTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :solid_cable_streams, if_exists: true
    drop_table :solid_cable_messages, if_exists: true
    drop_table :solid_cable_records, if_exists: true
  end
end