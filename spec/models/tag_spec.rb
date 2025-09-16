# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "associations" do
    it { should have_and_belong_to_many(:expenses) }
  end

  describe 'validations' do
    context 'for the fields length' do
      it { is_expected.to validate_length_of(:description).is_at_most(20) }
    end
    context 'for the fields presence' do
      it { should validate_presence_of :description }
    end
  end
end
