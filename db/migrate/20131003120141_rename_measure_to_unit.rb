class RenameMeasureToUnit < ActiveRecord::Migration
  def change
    rename_table 'Measures', 'Units'
  end
end
