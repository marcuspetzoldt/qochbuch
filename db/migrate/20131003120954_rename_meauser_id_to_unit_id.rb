class RenameMeauserIdToUnitId < ActiveRecord::Migration
  def change
    rename_column('taggings', 'measure_id', 'unit_id')
  end
end
