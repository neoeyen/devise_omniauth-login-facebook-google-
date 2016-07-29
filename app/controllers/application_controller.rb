class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :ensure_signup_complete #, only: [:new, :create, :update, :destroy]  필요한 컨트롤러에 설정

# 깃북 내용

  protected
  def ensure_signup_complete
   # Ensure we don't go into an infinite loop
   return if action_name == 'finish_signup'

   # Redirect to the 'finish_signup' page if the user
   # email hasn't been verified yet
   if user_signed_in? && current_user.require_password_reset?
     redirect_to finish_signup_path(current_user)
   end
  end

end
