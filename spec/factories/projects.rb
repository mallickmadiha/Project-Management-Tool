# frozen_string_literal: true

# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    user
    trait :with_long_name do
      name { 'a' * 256 }
    end
  end
end
