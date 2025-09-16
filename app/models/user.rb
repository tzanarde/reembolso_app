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

  # Validations
  validates :name, length: { maximum: 50 },
                   presence: true

  validates :email, length: { maximum: 60 },
                    presence: true

  validates :role, length: { maximum: 1 },
                   inclusion: { in: %w[M E] },
                   presence: true

  validates :active, presence: true

  validates :manager_user_id, presence: true, if: -> { role == "E" }
  validates :manager_user_id, absence: true, if: -> { role == "M" }

  # Scopes
  scope :managers, -> { where(role: 'M') }
end