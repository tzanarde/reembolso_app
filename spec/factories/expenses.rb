# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    sequence(:description) { |n| "Descrição da despesas #{n}" }
    sequence(:date) { |n| (Date.today - n).strftime("%Y-%m-%d") }
    amount { rand(10.00..100.00).round(2) }
    sequence(:location) { |n| "Local #{n}" }
    user

    trait :with_tags do
      transient do
        tags_count { 1 }
      end

      after(:build) do |expense, evaluator|
        evaluator.tags_count.times do
          expense.tags << build(:tag)
        end
      end
    end

    trait :with_nf_file do
      after(:build) do |expense|
        expense.receipt_nf.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/receipt_nf.png")),
          filename: "receipt_nf.png",
          content_type: "image/png"
        )
      end
    end

    trait :with_card_file do
      after(:build) do |expense|
        expense.receipt_card.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/receipt_card.png")),
          filename: "receipt_card.png",
          content_type: "image/png"
        )
      end
    end

    trait :pending do
      status { "P" }
    end

    trait :approved do
      status { "A" }
    end

    trait :declined do
      status { "D" }
    end
  end
end
