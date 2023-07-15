# spec/factories/details.rb
FactoryBot.define do
  factory :detail do
    association :project
    title { "Sample Title" }
    description { "Sample Description" }
    # Add any other necessary attributes or associations
  end
end
