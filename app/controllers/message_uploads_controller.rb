require 'liked_message_checker'

class MessageUploadsController < ApplicationController
  before_action :authenticate_admin!

  def new
  end

  def create
    begin
      messages = JSON.parse(params[:file].read, symbolize_names: true)

      if !Group.exists?(groupme_id: messages.first[:group_id])
        group_response = Group.get_info_from_groupme(messages.first[:group_id])

        if group_response[:meta][:code] == 200
          Group.create!(groupme_id: group_response[:response][:id], name: group_response[:response][:name])
        else
          # TODO: Make this display to the user
          return
        end
      end

      messages.each do |msg|
        next if !LikedMessage.liked_own_message?(msg)
        next if LikedMessage.exists?(groupme_id: msg[:id])

        if !User.exists?(groupme_id: msg[:user_id])
          User.create!(groupme_id: msg[:user_id], name: msg[:name])
        end

        LikedMessage.create!(
          user: User.find_by_groupme_id(msg[:user_id]),
          content: msg[:text],
          group: Group.find_by_groupme_id(msg[:group_id]),
          groupme_id: msg[:id],
          image_url: LikedMessage.get_image(msg),
          created_at: Time.at(msg[:created_at])
        )
      end

    rescue JSON::ParserError
      respond_to do |format|
        format.js { render partial: 'message_uploads/display_error.js.erb', locals: { error_msg: 'JSON is invalid.' } }
      end
    end
  end
end
