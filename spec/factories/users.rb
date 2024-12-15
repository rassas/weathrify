FactoryBot.define do
  factory :user do
    username { "John" }
    password { "password" }
    password_confirmation { "password" }
  end
end
