module Flashable
  extend ActiveSupport::Concern

  def set_flash_create
    flash[:show_modal_expense_created] = true
    flash[:modal_message] = t("messages.refound_request_sent")
  end

  def set_flash_update
    flash[:show_modal_expense_created] = true
    flash[:modal_message] = t("messages.refound_request_edited")
  end
end


