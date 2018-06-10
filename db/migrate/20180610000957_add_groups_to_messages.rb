class AddGroupsToMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :liked_messages, :group_groupme_id, :integer
    add_reference :liked_messages, :group, index: true
  end
end
