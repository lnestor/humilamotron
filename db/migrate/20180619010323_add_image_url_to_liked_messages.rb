class AddImageUrlToLikedMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :liked_messages, :image_url, :string
  end
end
