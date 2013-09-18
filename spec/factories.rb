FactoryGirl.define do
  factory :user do
    name "test"
    email "test@test.de"
    password "kennwort"
    password_confirmation "kennwort"
  end
end