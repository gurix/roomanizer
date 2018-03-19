FactoryBot.define do
  factory :booking do
    start_at { Time.now }
    end_at { Time.now + 2.hours }
  end
end
