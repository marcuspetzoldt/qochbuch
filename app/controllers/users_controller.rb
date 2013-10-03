class UsersController < ApplicationController

  include ApplicationHelper

  before_filter :require_login, except: [:new, :create]

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
#   render js: 'location.reload(true)'
    render js: "window.location='#{root_path}'"
  end

  def signout
    sign_out
    redirect_to root_path
  end

  def change_password
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  def update
    if params[:commit]
      @user = current_user
      if @user.authenticate(params[:password])
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        if !@user.save
          render('change_password')
          return
        end
      else
        flash.now[:error] = 'Wrong password.'
        render('change_password')
        return
      end
    end
    # Wait for the fade-out of the form to happen (850ms)
    sleep(1)
#   render js: 'location.reload(true)'
    render js: "window.location='#{root_path}'"

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
