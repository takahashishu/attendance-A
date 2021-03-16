class AddNumberInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :string
    add_column :users, :card_ID, :string
  end
end
