require 'faker'

FactoryGirl.define do
  factory :task do |f|
    f.name { Faker::Name.first_name}
    f.description {Faker::Lorem.sentence(rand(2..10)).chomp('.')}
    f.end_date_on { Faker::Date.backward}
    f.user_id {Faker::Number.between(1, 10)}
  end
end
