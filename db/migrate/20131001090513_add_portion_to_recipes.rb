class AddPortionToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :portion, :integer
  end
end
