class AddDetailsToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :stripe_payment_intent, :string
  end
end
