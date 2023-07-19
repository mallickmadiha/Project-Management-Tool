# frozen_string_literal: true

# spec/factories/chats.rb
FactoryBot.define do
  factory :chat do
    association :sender, factory: :user
    association :detail
    message { 'Sample message' }
  end
end
