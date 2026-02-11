FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_profile do
      first_name { 'Jenya' }
      last_name { 'Skubii' }
      gender { 'Female' }
      birth_date { '2007-08-25' }
    end
  end
end
