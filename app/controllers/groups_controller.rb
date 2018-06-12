class GroupsController < ApplicationController
  before_action :authenticate_admin!
  before_action :verify_groupme_id_is_passed!, only: :create
  before_action :call_groupme_api, only: :create

  def index
    @groups = Group.all
  end

  def create
    if(@parsed_response[:meta][:code] == 200)
      if !Group.exists?(groupme_id: params[:groupme_id])
        name = @parsed_response[:response][:name]
        Group.create(groupme_id: params[:groupme_id], name: name)
      else
        flash[:alert] = 'Group is already allowed.'
      end
    else
      flash[:alert] = 'Group Not Found'
    end

    redirect_to '/manage'
  end

  def destroy
    if Group.exists?(params[:id])
      Group.find(params[:id]).delete
      flash[:notice] = 'Successfully deleted group.'
    else
      flash[:alert] = 'Group not found.'
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

  def call_groupme_api
    response = Faraday.get(groups_url(params[:groupme_id]))
    @parsed_response = JSON.parse(response.body, symbolize_names: true)
  end
end
