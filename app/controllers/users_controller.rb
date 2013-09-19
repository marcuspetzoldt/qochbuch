class UsersController < ApplicationController
  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create

    if params[:commit]
      # Submit Button
      if params[:what] == 'signup'
        @user = User.new(user_params)
        if @user.save
          # Handle a successful save.
          sign_in(@user)
        else
          render('new')
          sleep(1)
          return
        end
      else
        user = User.find_by(email: params[:user][:email])
        if user && user.authenticate(params[:user][:password])
          sign_in(user)
        else
          @user = User.new(user_params)
          flash.now[:error] = 'Invalid user / password combination.'
          render('new')
          sleep(1)
          return
        end
      end
    end
    # Wait for the fade-out of the form to happen (850ms)
    sleep(1)
    render :js => "window.location.href='"+root_path+"'"
  end

  def signout
    sign_out
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
