class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path(logout: true)
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :manager_user_id, :active])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :manager_user_id, :active])
    end
end
