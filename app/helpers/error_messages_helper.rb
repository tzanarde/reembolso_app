module ErrorMessagesHelper
  def error_message(resource)
    if resource.errors.any?
      error_key = resource.errors.details.first[1].first[:error]
      attribute = resource.errors.details.first[0]

      if attribute == :password_confirmation && error_key == :confirmation
        error_key = :not_match
        attribute = 'password'
      elsif attribute == :role && error_key == :inclusion
        error_key = 'blank'
      end
      
      custom_key = "errors.forms.user_sign_up.#{attribute}.#{error_key}"

      I18n.t(custom_key, default: resource.errors.full_messages.first)
    end
  end
end
