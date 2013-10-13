class AddForeignkeyToImage < ActiveRecord::Migration
  def change
    add_column :images, :recipe_id, :integer
    add_index :images, [:recipe_id], name: 'fk_images_recipe_id', using: 'btree'
  end
end
