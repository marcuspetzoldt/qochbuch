class RenameNameOfImage < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.rename :name, :version
    end
  end
end
