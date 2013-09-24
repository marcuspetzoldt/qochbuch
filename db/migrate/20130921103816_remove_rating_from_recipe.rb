class RemoveRatingFromRecipe < ActiveRecord::Migration
  def change
    remove_column :recipes, :rating, :integer
  end
end
