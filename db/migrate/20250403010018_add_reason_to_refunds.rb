class AddReasonToRefunds < ActiveRecord::Migration[8.0]
  def change
    add_column :refunds, :reason, :string
  end
end
