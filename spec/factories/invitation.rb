FactoryBot.define do
  factory :invitation do
    space
    name { FFaker::Name.name }
    email { "#{name.downcase.gsub(' ', '-')}@example.com" }
    invitor factory: :person
  end
end