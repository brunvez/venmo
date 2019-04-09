def seed_database
  ActiveRecord::Base.transaction do
    users = create_users
    create_accounts(users)
    create_friends(users)
    create_payments(users)
  end
end

def create_users
  (0..10).map { |i| User.create!(name: "User #{i}", username: "user_#{i}") }
end

def create_accounts(users)
  (0..10).map { |i| PaymentAccount.create!(user: users[i], balance: i * 10) }
end

def create_friends(users)
  users.each_cons(2).each { |to_befriend| make_friends(*to_befriend) }
end

def create_payments(users)
  users.each_cons(2) do |(u1, u2)|
    4.times do |i|
      amount = rand(0.0..Payment::MAX_AMOUNT)
      if i.even?
        create_payment(u1, u2, amount)
      else
        create_payment(u2, u1, amount)
      end
    end
  end
end

def make_friends(first_user, second_user)
  Friendship.create!(first_user: first_user, second_user: second_user)
end

def create_payment(sender, receiver, amount)
  Payment.create!(sender: sender, receiver: receiver, amount: amount)
end

seed_database
