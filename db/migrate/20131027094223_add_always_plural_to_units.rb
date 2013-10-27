class AddAlwaysPluralToUnits < ActiveRecord::Migration
  def change
    add_column :units, :rule, :integer, default: 0
  end
end
