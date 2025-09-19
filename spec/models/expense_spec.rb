# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe "initializers" do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    let!(:expense) do
      create(:expense, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee)
    end
    it 'creates an expense with the default status values' do
      expect(expense.status).to include('P')
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:tags) }
    it { should have_one_attached(:receipt_nf) }
    it { should have_one_attached(:receipt_card) }
  end

  describe 'validations' do
    context 'for the fields length' do
      it { is_expected.to validate_length_of(:description).is_at_most(80) }
      it { is_expected.to validate_length_of(:location).is_at_most(50) }
      it { is_expected.to validate_length_of(:status).is_at_most(1).on(:update) }
    end
    context 'for the fields presence' do
      context 'for the general fields' do
        it { should validate_presence_of :description }
        it { should validate_presence_of :date }
        it { should validate_presence_of :amount }
        it { should validate_presence_of :location }
        it { should validate_presence_of(:status).on(:update) }
      end
      context 'for the tags' do
        let!(:manager) { create(:user, :manager) }
        let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
        let!(:tag) { create(:tag) }
        it 'validates the presence of the tags' do
          expense = Expense.new(description: 'Descrição',
                                date: Date.today,
                                amount: 10.0,
                                location: 'Local',
                                user: employee)

          expense.receipt_card.attach(io: File.open(Rails.root.join("spec/fixtures/files/receipt_card.png")),
                                      filename: "receipt_card.png",
                                      content_type: "image/png")

          expense.receipt_nf.attach(io: File.open(Rails.root.join("spec/fixtures/files/receipt_nf.png")),
                                    filename: "receipt_nf.png",
                                    content_type: "image/png")
                
          expense.save

          expect(expense.errors.details.first[0]).to eq(:tags)
          expect(expense.errors.details.first[1].first[:error]).to eq('blank')
        end
      end
      context 'for the files upload' do
        let!(:manager) { create(:user, :manager) }
        let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
        let!(:tag) { create(:tag) }
        context 'for the receipt_nf file' do
          it 'validates the presence of the receipt nf file' do
            expense = Expense.new(description: 'Descrição',
                                  date: Date.today,
                                  amount: 10.0,
                                  location: 'Local',
                                  tags: [tag],
                                  user: employee)

            expense.receipt_card.attach(io: File.open(Rails.root.join("spec/fixtures/files/receipt_card.png")),
                                        filename: "receipt_card.png",
                                        content_type: "image/png")
                  
            expense.save

            expect(expense.errors.details.first[0]).to eq(:receipt_nf)
            expect(expense.errors.details.first[1].first[:error]).to eq('blank')
          end
        end
        context 'for the receipt_card file' do
          it 'validates the presence of the receipt card file' do
            expense = Expense.new(description: 'Descrição',
                                  date: Date.today,
                                  amount: 10.0,
                                  location: 'Local',
                                  tags: [tag],
                                  user: employee)

            expense.receipt_nf.attach(io: File.open(Rails.root.join("spec/fixtures/files/receipt_nf.png")),
                                      filename: "receipt_nf.png",
                                      content_type: "image/png")
                  
            expense.save

            expect(expense.errors.details.first[0]).to eq(:receipt_card)
            expect(expense.errors.details.first[1].first[:error]).to eq('blank')
          end
        end
      end
    end
  end

  describe "relationships" do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    let!(:expense) do
      create(:expense, :pending, :with_tags, :with_nf_file, :with_card_file, tags_count: 3, user: employee)
    end
    let!(:tag) { create(:tag) }

    it 'allows association and access to the tags' do
      expense.tags << tag

      expect(expense.tags).to include(tag)
      expect(tag.expenses).to include(expense)
    end

    it 'allows deletion of a tag' do
      expense.tags << tag
      expense.tags.destroy(tag)

      expect(expense.tags).to_not include(tag)
    end
  end
end
