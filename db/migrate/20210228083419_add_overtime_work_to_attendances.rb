class AddOvertimeWorkToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :scheduled_end_time, :datetime
    add_column :attendances, :overtime, :datetime
    add_column :attendances, :business_processing_content, :string
    add_column :attendances, :instructor_confirmation, :string
  end
end
