class GroupChecksController < ApplicationController
  before_action :verify_params!
  before_action :call_groupme_api

  def create
    if @code == 200
      if !Group.exists?(groupme_id: params[:groupme_id])
        group_name = @parsed_response[:response][:name]

        respond_to do |format|
          format.js { render partial: 'groups/confirmation.js.erb', locals: { group_name: group_name, groupme_id: params[:groupme_id] } }
      end
      else
        respond_to do |format|
          format.js { render partial: 'groups/already_exists.js.erb' }
        end
      end
    else
      display_not_found
    end
  end

  private

  def verify_params!
    display_not_found if params[:groupme_id].blank?
  end
  
  def groups_url(id)
    "https://api.groupme.com/v3/groups/#{id}?access_token=#{ENV['access_token']}"
  end

  def call_groupme_api
    response = Faraday.get(groups_url(params[:groupme_id]))
    @parsed_response = JSON.parse(response.body, symbolize_names: true)
    @code = @parsed_response[:meta][:code]
  end

  def display_not_found
    respond_to do |format|
      format.js { render partial: 'groups/group_not_found.js.erb' }
    end
  end
end
