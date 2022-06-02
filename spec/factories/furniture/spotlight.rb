FactoryBot.define do
  factory :spotlight do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, { furniture_kind: 'spotlight', room: room }
    end
  end

  factory :spotlight_image_file, class: 'Spotlight::ImageFile' do
    association :space

    transient do
      room { build(:room) }
    end

    location do
      association :furniture_placement, { furniture_kind: 'spotlight', room: room }
    end

    file { Rack::Test::UploadedFile.new("spec/fixtures/cc-kitten.jpg", "image/jpeg") }
  end
end
