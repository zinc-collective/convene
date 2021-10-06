FactoryBot.define do
  factory :check_dropbox, class: 'Furniture::CheckDropbox' do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, { furniture_kind: 'check_dropbox', room: room }
    end
  end
end
