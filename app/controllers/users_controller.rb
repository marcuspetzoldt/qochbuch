class UsersController < ApplicationController
  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create

    if (params[:commit].nil?)
      # Cancel Button
      @cancel = true
      render 'new'
    else
      # Submit Button
      @user = User.new(user_params)
      if @user.save
        # Handle a successful save.
      else
        render 'new'
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
