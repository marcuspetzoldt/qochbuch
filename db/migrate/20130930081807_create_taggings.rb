class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :recipe_id
      t.integer :tag_id
      t.float :amount
      t.integer :measure_id

      t.timestamps
    end
  end
end
