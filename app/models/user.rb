# frozen_string_literal: true

class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Relationships
  belongs_to :manager_user, class_name: "User",
                            optional: true

  has_many :child_user, class_name: "User",
                        foreign_key: "manager_user_id",
                        dependent: :nullify

  # Scopes
  scope :managers, -> { where(role: 'M') }
end