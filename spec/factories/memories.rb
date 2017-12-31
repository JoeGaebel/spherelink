FactoryGirl.define do
  factory :memory do
    transient do
      sphere_count 1
    end

    user
    name { Faker::App.name }

    after(:create) do |memory, evaluator|
      create_list(:sphere, evaluator.sphere_count, memory: memory)
    end
  end
end
