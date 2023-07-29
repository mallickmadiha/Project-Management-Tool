# frozen_string_literal: true

# spec/factories/details.rb
FactoryBot.define do
  factory :detail do
    association :project
    title { 'Sample Title' }
    description { 'Sample Description' }
  end
end
