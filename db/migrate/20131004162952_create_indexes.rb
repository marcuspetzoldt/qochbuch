class CreateIndexes < ActiveRecord::Migration
  def change
    add_index 'taggings', ['recipe_id'], name: 'fk_taggings_user_id', using: :btree
    add_index 'taggings', ['tag_id'], name: 'fk_taggings_tag_id', using: :btree
    add_index 'taggings', ['unit_id'], name: 'fk_taggings_unit_id', using: :btree
    add_index 'tags', ['tag'], name: 'ft_tags', type: :fulltext
    add_index 'tags', ['tag'], name: 'idx_tags_tag', using: :btree
    add_index 'tags', ['category', 'tag'], name: 'idx_tags_category_tag', using: :btree
    add_index 'recipes', ['title', 'description', 'directions'], name: 'ft_recipes', type: :fulltext
  end
end
