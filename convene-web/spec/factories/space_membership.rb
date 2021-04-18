FactoryBot.define do
  factory :space_membership do
    space
    member factory: :person
  end
end
