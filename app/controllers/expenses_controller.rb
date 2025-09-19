class ExpensesController < ApplicationController
  include Flashable

  before_action :authenticate_user!
  before_action :set_expense, only: %i[ show edit update destroy approve decline ]
  before_action :authorize_expense!, only: %i[show edit update destroy approve decline]
  before_action :build_expense, only: %i[ create ]
  before_action :set_tags, only: %i[ create update ]

  def index
    @expenses = Expense.pick_role(Expense.pick_type(params['type']), current_user)

    @expenses = Expense.filter_group(@expenses, params)
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def edit
  end
  
  def create
    if @expense.save
      set_flash_create

      redirect_to @expense
    else
      render :new, status: :unprocessable_content
    end
  end
  
  def update
    if @expense.update(expense_params.except(:tag_names))
      set_flash_update

      redirect_to @expense
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @expense.destroy!
    
    redirect_to expenses_url
  end

  def approve
    if @expense.can_be_approved?(current_user)
      @expense.approve!

      redirect_to expenses_path(type: 'history')
    else
      redirect_to expenses_path(type: 'pending')
    end
  end

  def decline
    if @expense.can_be_declined?(current_user)
      @expense.decline!

      redirect_to expenses_path(type: 'history')
    else
      redirect_to expenses_path(type: 'pending')
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def set_tags
    @expense.tags_param = { tag_names: expense_params[:tag_names] }
  end

  def build_expense
    @expense = Expense.new(expense_params.except(:tag_names))
  end

  def expense_params
    params.require(:expense)
          .permit(:description, :date, :amount, :location, :status, :user_id, :text_filter, :receipt_nf, :receipt_card, tag_names: [])
          .merge(user_id: current_user.id)
  end

  def authorize_expense!
    redirect_to expenses_path(type: 'pending') unless @expense.accessible_by?(current_user)
  end
end
