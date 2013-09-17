class UsersController < ApplicationController
  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create

    @close = false
    if (params[:cancel])
      # Cancel Button
      @close = true
      render 'new'
    else
      # Submit Button
      @user = User.new(user_params)
      if @user.save
        # Handle a successful save.
        @close = true
      end
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
