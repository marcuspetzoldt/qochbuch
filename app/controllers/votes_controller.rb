class VotesController < ApplicationController

  def edit
    # Voting user is signed in user
    if params[:user_id].to_i == current_user.id
      # Voting user does not vote for own recipe
      if params[:user_id] != Recipe.find(params[:recipe_id]).user.id
        if v = Vote.find_by(user_id: params[:user_id], recipe_id: params[:recipe_id])
          # Update vote
          v.vote = params[:id]
          v.save
        else
          # First vote
          v = Vote.new(user_id: params[:user_id], recipe_id: params[:recipe_id], vote: params[:id])
          v.save
        end
      end
    end
    redirect_to(recipe_path(params[:recipe_id]))
  end

end
