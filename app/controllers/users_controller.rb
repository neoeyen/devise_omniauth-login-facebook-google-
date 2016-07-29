class UsersController < ApplicationController
  before_action :set_user, only: [:finish_signup]

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end



  private

    def set_user
      @user = User.find(params[:id])
      name = @user.name.split("_")  # 왜 안들어가는건지 몰라서 DB 테이블을 생성할까 하다가 더공부해서 없애는걸로~ ㅠㅠ
      @user.name = name[0]
    end

    def user_params
      accessible = [ :name, :image, :password, :password_confirmation ] # extend with your own params
      # accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
