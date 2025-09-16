# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:tags) }
    # it { should have_one_attached(:receipt_nf) }
    # it { should have_one_attached(:receipt_card) }
  end

  describe 'validations' do
    context 'for the fields length' do
      it { is_expected.to validate_length_of(:description).is_at_most(80) }
      it { is_expected.to validate_length_of(:location).is_at_most(50) }
      it { is_expected.to validate_length_of(:status).is_at_most(1) }
    end
    context 'for the fields presence' do
      it { should validate_presence_of :description }
      it { should validate_presence_of :date }
      it { should validate_presence_of :amount }
      it { should validate_presence_of :location }
      it { should validate_presence_of :status }
    end
  end

  describe "relationships" do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee, manager_user_id: manager.id) }
    let!(:expense) { create(:expense, :pending, user: employee) }
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
