class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        flash[:show_modal] = true
        flash[:modal_message] = t("messages.user_register_request_sent_message")
      end
    end
  end

  def update
    super do |resource|
      if resource.persisted?
        flash[:show_modal] = true
        flash[:modal_message] = t("messages.user_edited")
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    root_path
  end
end
