module ExpensesHelper
  def expenses_title(params, current_user)
    if params[:type] == 'pending'
      current_user.employee? ? t("titles.my_pending_expenses") : t("titles.pending_expenses")
    elsif params[:type] == 'history'
      current_user.employee? ? t("titles.my_request_history") : t("titles.request_history")
    else
      t("titles.request_history")
    end
  end

  def formatted_expense_date(expense)
    expense.date.strftime("%d/%b")
  end

  def formatted_expense_amount(expense)
    number_to_currency(expense.amount, unit: "R$ ", separator: ",", delimiter: ".")
  end

  
end
