# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:child_user).class_name('User').with_foreign_key('manager_user_id').dependent(:nullify) }
    it { is_expected.to belong_to(:manager_user).class_name('User').optional }
  end

  describe 'validations' do
    context 'for the fields length' do
      it { is_expected.to validate_length_of(:name).is_at_most(50) }
      it { is_expected.to validate_length_of(:email).is_at_most(60) }
      it { is_expected.to validate_length_of(:role).is_at_most(1) }
    end

    context 'for the fields content' do
      it { is_expected.to validate_inclusion_of(:role).in_array(%w[M E]) }
    end

    context 'for the fields presence' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_presence_of(:active) }
    end
  end

  describe 'scopes' do
    let!(:manager) { create(:user, :manager) }
    let!(:employee) { create(:user, :employee) }

    it 'returns only managers' do
      expect(User.managers).to include(manager)
      expect(User.managers).not_to include(employee)
    end
  end
end
