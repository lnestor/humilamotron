class GroupChecksController < ApplicationController
  before_action :verify_params!
  before_action :call_api

  def create
    if @code == 200
      group_name = @parsed_response[:response][:name]

      respond_to do |format|
        format.js { render partial: 'groups/confirmation.js.erb', locals: { group_name: group_name } }
      end
    else
      respond_to do |format|
        format.js { render partial: 'groups/group_not_found.js.erb' }
      end
    end
  end

  private

  def verify_params!
    if params[:groupme_id].blank?
      flash[:alert] = 'Please pass a valid ID.'
      head :no_content
    end
  end
  
  def groups_url(id)
    "https://api.groupme.com/v3/groups/#{id}?access_token=#{ENV['access_token']}"
  end

  def call_api
    response = Faraday.get(groups_url(params[:groupme_id]))
    @parsed_response = JSON.parse(response.body, symbolize_names: true)
    @code = @parsed_response[:meta][:code]
  end
end
