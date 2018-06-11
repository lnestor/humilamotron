class GroupsController < ApplicationController
  before_action :authenticate_admin!
  before_action :verify_groupme_id_is_passed!, only: :create

  def index
    @groups = Group.all
  end

  def create
    response = Faraday.get(groups_url(params[:groupme_id]))

    if(response.code == '200')
      name = JSON.parse(response.body, symbolize_names: true)[:response][:name]
      Group.create(groupme_id: params[:groupme_id], name: name)
    else
      flash[:alert] = 'Group Not Found'
    end

    redirect_to '/manage'
  end

  private

  def groups_url(id)
    "https://api.groupme.com/v3/groups/#{id}?access_token=#{ENV['access_token']}"
  end

  def verify_groupme_id_is_passed!
    if params[:groupme_id].blank?
      flash[:alert] = 'You must pass an ID'
      redirect_to '/manage'
    end
  end
end
