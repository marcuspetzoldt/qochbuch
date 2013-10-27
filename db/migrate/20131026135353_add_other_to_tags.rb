class AddOtherToTags < ActiveRecord::Migration
  def change
    add_column :tags, :other, :string
  end
end
