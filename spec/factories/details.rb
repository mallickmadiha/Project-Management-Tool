# frozen_string_literal: true

# spec/factories/details.rb
FactoryBot.define do
  factory :detail do
    association :project
    sequence(:title) { |n| "Sample Title #{n}" }
    description { 'Sample Description' }
  end
end
