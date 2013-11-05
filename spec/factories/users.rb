# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    firstname "MyText"
    lastname "MyText"
    identificationtype "MyText"
    identification "MyText"
    status "MyText"
    usertype "MyText"
    email "MyText"
    password "MyText"
    code "MyText"
  end
end
