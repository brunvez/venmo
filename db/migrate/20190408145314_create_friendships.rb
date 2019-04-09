class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :first_user_id, index: true, null: false
      t.integer :second_user_id, index: true, null: false

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :first_user_id
    add_foreign_key :friendships, :users, column: :second_user_id
  end
end
