class AddOtherToUnits < ActiveRecord::Migration
  def change
    add_column :units, :other, :string
  end
end
