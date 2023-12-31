# frozen_string_literal: true

# spec/factories/notifications.rb
FactoryBot.define do
  factory :notification do
    message { 'Test notification' }
    association :user
  end
end
