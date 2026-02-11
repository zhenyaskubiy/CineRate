FactoryBot.define do
  factory :user_movie do
    association :user
    sequence(:tmdb_id) { |n| n }
    status { :want_to_watch }
    runtime { 0 }
    rating { nil }

    trait :watched do
      status { :watched }
      runtime { 120 }
    end

    trait :want_to_watch do
      status { :want_to_watch }
      runtime { 0 }
    end

    trait :not_interested do
      status { :not_interested }
      runtime { 0 }
    end
  end
end
