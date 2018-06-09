class CreateLikedMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :liked_messages do |t|
      t.string :content
      t.integer :groupme_id
      t.references :user
      t.integer :group_groupme_id

      t.timestamps
    end

    add_index :liked_messages, :groupme_id, unique: true
  end
end
