class AddDescriptionToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :description, :string
  end
end
