class UsersController < ApplicationController

  include ApplicationHelper

  before_action :require_login, except: [:new, :create]
  before_action :is_admin?, only: [:index, :destroy]

  PAGINATION = 25

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
          flash.now[:error] = t('views.users.invalid_user_email_combination')
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
        flash.now[:error] = t('views.users.wrong_password')
        render('change_password')
        return
      end
    end
    # Wait for the fade-out of the form to happen (850ms)
    sleep(1)
#   render js: 'location.reload(true)'
    render js: "window.location='#{root_path}'"

  end

  def index
    @sort_by, @sort_direction = sort_by_column(name: params[:name],
                                               email: params[:email],
                                               created_at: params[:created_at],
                                               recipes: params[:recipes])

    if @sort_by == :recipes
      if @sort_direction == 1
        u =
          User.all.sort do |a,b|
            a.recipes.count <=> b.recipes.count
          end
      else
        u =
          User.all.sort do |a,b|
            b.recipes.count <=> a.recipes.count
          end
      end
    else
      u = User.all.order(@sort_by => (@sort_direction == 1 ? :asc : :desc))
    end
    @page = params[:page] ? params[:page].to_i : 0
    @max_page = u.count / PAGINATION - ((u.count % PAGINATION > 0) ? 0 : 1)
    @users = u[@page*PAGINATION..@page*PAGINATION+PAGINATION-1]
  end

  def destroy
    if params[:id].present?
      u = User.find(params[:id])
      if u
        if u.recipes.count == 0
          u.destroy
        else
          flash[:error] = t('views.users.invalid_user_has_recipes')
        end
      else
        flash[:error] = t('views.users.invalid_user_id')
      end
    end
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
