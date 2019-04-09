class ChangeBalanceToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :payment_accounts, :balance, :float
  end
end
