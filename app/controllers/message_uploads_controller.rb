require 'liked_message_checker'

class MessageUploadsController < ApplicationController
  before_action :authenticate_admin!

  def new
  end

  def create
    begin
      messages = JSON.parse(params[:file].read, symbolize_names: true)

      messages.each do |message|
        LikedMessageChecker.check_message(message)
      end
    rescue JSON::ParserError
      respond_to do |format|
        format.js { render partial: 'message_uploads/display_error.js.erb', locals: { error_msg: 'JSON is invalid.' } }
      end
    rescue
      respond_to do |format|
        format.js { render partial: 'message_uploads/display_error.js.erb', locals: { error_msg: 'JSON is valid but not in format expected.' } }
      end
    end
  end
end
