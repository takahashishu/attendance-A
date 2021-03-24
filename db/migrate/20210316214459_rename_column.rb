class RenameColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :work_time, :designated_work_start_time
    rename_column :users, :designated_work_start_time, :work_time
  end
end
