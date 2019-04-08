class User < ApplicationRecord
  has_many :friendships_as_first_user,
           foreign_key: :first_user_id, class_name: Friendship.to_s, dependent: :destroy
  has_many :friendships_as_second_user,
           foreign_key: :second_user_id, class_name: Friendship.to_s, dependent: :destroy
  has_many :sent_payments, foreign_key: :sender_id, class_name: Payment.to_s, dependent: :destroy
  has_many :received_payments, foreign_key: :receiver_id, class_name: Payment.to_s, dependent: :destroy

  has_one :payment_account

  validates :username, uniqueness: true

  def friendships
    friendships_as_first_user.or(friendships_as_second_user)
  end

  def friends
    User.joins("INNER JOIN (#{friendships.to_sql}) user_friendships
                  ON user_friendships.first_user_id = users.id
                    OR user_friendships.second_user_id = users.id")
      .where.not(id: id)
  end
end
