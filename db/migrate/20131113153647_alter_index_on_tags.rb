class AlterIndexOnTags < ActiveRecord::Migration
  def change
    remove_index "tags", name: 'idx_tags_tag'
    execute( 'CREATE INDEX idx_tags_tag ON tags(LOWER(tag))')
    execute( 'CREATE INDEX idx_tags_other ON tags(LOWER(other))')
  end
end
