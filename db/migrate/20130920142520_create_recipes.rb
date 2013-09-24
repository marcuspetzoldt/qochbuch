class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :time
      t.integer :level
      t.integer :rating
      t.string :title
      t.string :description
      t.text :directions

      t.timestamps
    end
  end
end
