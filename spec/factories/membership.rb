FactoryBot.define do
  factory :membership do
    space
    member factory: :person
  end
end
