class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :nationality, :string
    add_column :users, :birthday, :date
  end
end
