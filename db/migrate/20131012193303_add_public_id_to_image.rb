class AddPublicIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :public_id, :string
  end
end
