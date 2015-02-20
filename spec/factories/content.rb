FactoryGirl.define do
  factory :content do
    title "Файл"
    tags "ruby rails coffescript"
    file File.open(Rails.root.join('spec/fixtures/image.jpeg'))
  end
end