# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { 'password_digest' }
  end
end
