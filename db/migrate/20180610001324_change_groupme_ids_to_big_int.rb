class ChangeGroupmeIdsToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :groups, :groupme_id, :bigint
    change_column :liked_messages, :groupme_id, :bigint
    change_column :users, :groupme_id, :bigint
  end
end
