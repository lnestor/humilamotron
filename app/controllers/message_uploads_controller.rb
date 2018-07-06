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
    rescue
    end
  end
end
