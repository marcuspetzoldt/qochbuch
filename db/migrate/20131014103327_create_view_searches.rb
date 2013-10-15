class CreateViewSearches < ActiveRecord::Migration
    def up
      execute <<-SQL
      CREATE VIEW searches AS SELECT
        recipes.id as searchable_id,
        'Recipe' as searchable_type,
        recipes.title as term
      FROM recipes
      UNION SELECT
        recipes.id as searchable_id,
        'Recipe' as searchable_type,
        recipes.description as term
      FROM recipes
      UNION SELECT
        recipes.id as searchable_id,
        'Recipe' as searchable_type,
        recipes.directions as term
      FROM recipes
      UNION SELECT
        recipes.id as searchable_id,
        'Recipe' as searchable_type,
        tags.tag as term
      FROM recipes
      JOIN taggings
      ON recipes.id = taggings.recipe_id
      JOIN tags
      ON tags.id = taggings.tag_id
      SQL
    end

    def down
      execute <<-SQL
      DROP VIEW searches
      SQL
    end
end
