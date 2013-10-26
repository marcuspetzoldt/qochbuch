class VotesController < ApplicationController

  include ApplicationHelper

  before_action :require_login

  def edit
    # Voting user does not vote for own recipe
    if current_user.id != Recipe.find(params[:recipe_id]).user.id
      if v = Vote.find_by(user_id: current_user.id, recipe_id: params[:recipe_id])
        # Update vote
        v.vote = params[:id]
      else
        # First vote
        v = Vote.new(user_id: current_user.id, recipe_id: params[:recipe_id], vote: params[:id])
      end
      v.save
    end
    redirect_to(recipe_path(params[:recipe_id]))
  end

end
