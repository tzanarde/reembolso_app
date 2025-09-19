# frozen_string_literal: true

class Expense < ApplicationRecord
  # Callbacks
  before_validation :set_default_status, on: :create
  before_validation :add_tags, on: :create, if: -> { tags_param.present? }
  before_validation :update_tags, on: :update, if: -> { tags_param.present? }

  # Attributos
  attr_accessor :tags_param

  # Relationships
  belongs_to :user

  has_and_belongs_to_many :tags

  has_one_attached :receipt_nf

  has_one_attached :receipt_card

  delegate :manager_user, to: :user, allow_nil: true  

  # Validations
  validates :description, presence: true,
                          length: { maximum: 80 }

  validates :date, presence: true

  validates :amount, presence: true

  validates :location, presence: true,
                       length: { maximum: 50 }

  validates :status,  presence: true,
                      length: { maximum: 1 },
                      inclusion: { in: %w[P A D],
                                   message: "%{value} não é um status válido!" }

  # validates :tags, presence: true

  validate :must_have_tags

  validate :receipt_nf_presence
  
  validate :receipt_card_presence

  # Scopes
  scope :pending, -> { where(status: 'P') }

  scope :history, -> { where("status IN ('A', 'D')") }

  scope :by_description, ->(description) do
    where("UPPER(description) LIKE ?", "%#{description.upcase}%") if description.present?
  end

  scope :by_date, ->(date) do
    where(date: date) if date.present?
  end

  scope :by_date_period, ->(start_date, final_date) do
    expense = where("date BETWEEN ? AND ?", start_date, final_date) if start_date.present? and final_date.present?
    expense = where("date BETWEEN ? AND ?", start_date, Date.today.to_s) if start_date.present? and final_date.nil?

    expense
  end

  scope :by_employee_id, ->(employee_id) do
    where(user_id: employee_id) if employee_id.present?
  end
  
  scope :by_manager_id, ->(manager_id) do
    joins(:user).where(users: { manager_user_id: manager_id })
  end

  scope :by_location, ->(location) do
    where("UPPER(location) LIKE ?", "%#{location.upcase}%") if location.present?
  end

  scope :by_status, ->(status) do
    where(status: status) if status.present?
  end

  scope :by_amount, ->(min_amount, max_amount) do
    where("amount >= ? AND amount <= ?", min_amount, max_amount) if min_amount.present? and max_amount.present?
  end

  scope :by_tags, ->(tags) do
    joins(:tags).where(tags: { description: tags }).distinct if tags.present?
  end

  scope :pending_expenses_by_employee, ->(employee) do
    where(user: employee, status: 'P')
  end

  scope :todays_pending_expenses_by_employee, ->(employee) do
    where(user: employee, status: 'P', date: Date.today)
  end

  scope :week_pending_expenses_by_employee, ->(employee) do
    where(user: employee, status: 'P', date: Date.today.beginning_of_week(:monday)..Date.today.end_of_week(:sunday))
  end

  scope :pending_expenses_by_manager, ->(manager) do
    joins(:user).where(users: { manager_user_id: manager.id }, status: 'P')
  end

  scope :todays_pending_expenses_by_manager, ->(manager) do
    joins(:user).where(users: { manager_user_id: manager.id }, status: 'P', date: Date.today)
  end

  scope :week_pending_expenses_by_manager, ->(manager) do
    joins(:user).where(users: { manager_user_id: manager.id }, status: 'P', date: Date.today.beginning_of_week(:monday)..Date.today.end_of_week(:sunday))
  end

  # Methods
  def self.filter_group(expenses, params)
    expenses = expenses.by_description(params[:description]) if params[:description].present?
    expenses = expenses.by_date(params[:date]) if params[:date].present?
    expenses = expenses.by_date_period(params[:start_date], params[:final_date]) if params[:start_date].present? || params[:final_date].present?
    expenses = expenses.by_employee_id(params[:employee_id]) if params[:employee_id].present?
    expenses = expenses.by_location(params[:location]) if params[:location].present?
    expenses = expenses.by_amount(params[:min_amount], params[:max_amount]) if params[:min_amount].present? && params[:max_amount].present?
    expenses = expenses.by_tags(params[:tags]) if params[:tags].present? && params[:tags].reject(&:blank?).any?
    expenses = expenses.by_status(params[:status]) if params[:status].present?
    expenses
  end

  def full_status
    return I18n.t("status.pending") if status == 'P'
    return I18n.t("status.approved") if status == 'A'
    I18n.t("status.declined") if status == 'D'
  end

  def pending?
    status == 'P'
  end

  def accessible_by?(user)
    if user.employee?
      self.user_id == user.id
    elsif user.manager?
      self.user.manager_user_id == user.id
    else
      false
    end
  end

  def can_be_approved?(user)
    user.manager? && self.status == 'P'
  end

  def can_be_declined?(user)
    user.manager? && self.status == 'P'
  end

  def approve!
    update!(status: 'A')
  end

  def decline!
    update!(status: 'D')
  end

  def self.pick_type(type)
    if type == 'pending'
      Expense.pending
    elsif type == 'history'
      Expense.history
    end
  end

  def self.pick_role(expenses, user)
    if user.employee?
      expenses.by_employee_id(user.id)
    elsif user.manager?
      expenses.by_manager_id(user.id)
    end
  end

  def status_class
    case status
    when 'P' then 'pending'
    when 'A' then 'approved'
    when 'D' then 'declined'
    end
  end

  private

  def must_have_tags
    errors.add('tags', "blank") if tags.empty?
  end

  def receipt_nf_presence
    errors.add('receipt_nf', 'blank') unless receipt_nf.attached?
  end

  def receipt_card_presence
    errors.add('receipt_card', 'blank') unless receipt_card.attached?
  end

  def set_default_status
    self.status ||= 'P'
  end

  def add_tags
    if tags_param[:tag_names].present?
      tags_param[:tag_names].each do |tag_name|
        tags << Tag.find_or_create_by(description: tag_name.strip)
      end
    end
  end

  def update_tags
    if tags_param[:tag_names].present?
      current_tag_names = tags.pluck(:description)
      tags_to_process = tags_param[:tag_names].map(&:strip)

      tags_to_remove = current_tag_names - tags_to_process
      tags_to_add    = tags_to_process - current_tag_names

      tags.where(description: tags_to_remove).each do |tag|
        tags.destroy(tag)
      end

      tags_to_add.each do |tag_name|
        tags << Tag.find_or_create_by(description: tag_name)
      end
    else
      tags.each do |tag|
        tags.destroy(tag)
      end
    end
  end
end
