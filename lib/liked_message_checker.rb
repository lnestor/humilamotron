class LikedMessageChecker
  def self.check_message(msg)
    return unless msg[:favorited_by].include?(msg[:user_id])
    return unless !LikedMessage.exists?(groupme_id: msg[:id])

    if !User.exists?(groupme_id: msg[:user_id])
      User.create!(groupme_id: msg[:user_id], name: msg[:name])
    end

    LikedMessage.create!(
      user: User.find_by_groupme_id(msg[:user_id]),
      content: msg[:text],
      group: Group.find_by_groupme_id(msg[:group_id]),
      groupme_id: msg[:id],
      image_url: message_image(msg),
      created_at: Time.at(msg[:created_at])
    )
  end

  private

  def self.message_image(msg)
    msg[:attachments].each do |attachment|
      if attachment[:type] == 'image'
        return attachment[:url]
      end
    end
    nil
  end
end
