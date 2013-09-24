class AddRecipeRefToVotes < ActiveRecord::Migration
  def change
    add_reference :votes, :recipe, index: true
  end
end
