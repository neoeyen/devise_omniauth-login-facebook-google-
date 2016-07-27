class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :configure_devise_permitted_parameters, if: :devise_controller?

# 깃북 내용
  def ensure_signup_complete
   # Ensure we don't go into an infinite loop
   return if action_name == 'finish_signup'

   # Redirect to the 'finish_signup' page if the user
   # email hasn't been verified yet
   if current_user && !current_user.password_reset?
     redirect_to finish_signup_path(current_user)
   end
  end

  # protected 메소드는 위 주석의 configure_devise_permitted_parameters 정의 - 오류뜸 ㅠㅠ
  protected

  def configure_devise_permitted_parameters
      permitted_params = [:email, :password, :password_confirmation, :name, :image]

      if params[:action] == 'update'
        devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(permitted_params << :current_password)
        }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(permitted_params)
        }
      end
  end

end
