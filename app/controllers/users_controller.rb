class UsersController < ApplicationController
  before_action :authenticate_admin!, only: :destroy

  def index
    @users = User.all.sort_by { |u| u.liked_messages.count }.reverse
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).delete
    redirect_to root_path
  end
end
