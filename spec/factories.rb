FactoryGirl.define do
  factory :user do
    name 'test'
    email 'test@test.de'
    password 'kennwort'
    password_confirmation 'kennwort'
  end

  factory :recipe do
    association :user
    time 10
    level 1
    title 'Title'
    description 'Description'
    directions 'Directions'
  end
end