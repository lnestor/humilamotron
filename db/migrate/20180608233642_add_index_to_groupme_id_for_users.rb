class AddIndexToGroupmeIdForUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :groupme_id, unique: true
  end
end
