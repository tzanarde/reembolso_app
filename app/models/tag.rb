# frozen_string_literal: true

class Tag < ApplicationRecord
  # Relationships
  has_and_belongs_to_many :expenses

  # Validations
  validates :description, presence: true,
                          length: { maximum: 20 }
end
