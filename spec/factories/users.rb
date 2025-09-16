# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { "123456" }
    password_confirmation { "123456" }
    active { true }

    trait :manager do
      sequence(:email) { |n| "manager#{n}@email.com" }
      name { "Manager Name" }
      role { "M" }
      manager_user_id { nil }
    end

    trait :employee do
      sequence(:email) { |n| "employee#{n}@email.com" }
      name { "Employee Name" }
      role { "E" }
      manager_user_id { nil }
    end
  end
end