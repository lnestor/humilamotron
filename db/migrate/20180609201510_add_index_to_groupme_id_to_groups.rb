class AddIndexToGroupmeIdToGroups < ActiveRecord::Migration[5.2]
  def change
    add_index :groups, :groupme_id, unique: true
  end
end
