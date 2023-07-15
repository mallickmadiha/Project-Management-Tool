# rubocop:disable  all

# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    name { 'Sample Project' }
    user
    # Add any other attributes you want to include

    trait :with_long_name do
      name { 'a' * 256 }
    end
  end
end
