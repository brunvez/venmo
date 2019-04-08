class Friendship < ApplicationRecord
  belongs_to :first_user, class_name: 'User'
  belongs_to :second_user, class_name: 'User'

  validate :not_already_friends
  validate :not_befriend_oneself

  private

  def not_already_friends
    return unless Friendship.where(first_user_id:  [first_user_id, second_user_id],
                                   second_user_id: [first_user_id, second_user_id]).exists?
    errors.add(:base, I18n.t('api.errors.models.friendship.already_friends'))
  end

  def not_befriend_oneself
    return unless first_user == second_user
    errors.add(:base, I18n.t('api.errors.models.friendship.cannot_befriend_yourself'))
  end
end
