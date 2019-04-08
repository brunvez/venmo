class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :sender_id, index: true, null: false
      t.integer :receiver_id, index: true, null: false
      t.integer :amount

      t.timestamps
    end
    add_foreign_key(:payments, :users, column: :receiver_id)
    add_foreign_key(:payments, :users, column: :sender_id)
  end
end
