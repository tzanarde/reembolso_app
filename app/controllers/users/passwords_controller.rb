class Users::PasswordsController < Devise::PasswordsController
  def create
    super do |resource|
      if resource.persisted?
        flash[:show_modal_forgot_password] = true
        flash[:modal_message] = t("devise.passwords.send_instructions")
      end
    end
  end
end