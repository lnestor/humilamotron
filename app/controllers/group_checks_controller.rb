class GroupChecksController < ApplicationController
  before_action :verify_params!
  before_action :call_groupme_api

  def create
    if @code == 200
      if !Group.exists?(groupme_id: params[:groupme_id])
        display_group_add
      else
        display_already_exists
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
    "https://api.groupme.com/v3/groups/#{id}?access_token=#{ENV['GROUPME_ACCESS_TOKEN']}"
  end

  def call_groupme_api
    response = Faraday.get(groups_url(params[:groupme_id]))
    @parsed_response = JSON.parse(response.body, symbolize_names: true)
    @code = @parsed_response[:meta][:code]
  end

  def display_modal(partial_name:, local_vars: {})
    render partial: 'groups/confirmation.js.erb', locals: { partial: partial_name, locals_hash: local_vars }
  end

  def display_not_found
    respond_to do |format|
      format.js { display_modal partial_name: 'group_not_found' }
    end
  end

  def display_already_exists
    respond_to do |format|
      format.js { display_modal partial_name: 'group_already_exists' }
    end
  end
  
  def display_group_add
    group_name = @parsed_response[:response][:name]
    group_image = @parsed_response[:response][:image_url]

    respond_to do |format|
      format.js do
        display_modal partial_name: 'group_add', local_vars: { group_name: group_name, groupme_id: params[:groupme_id], group_image: group_image }
      end
    end
  end
end
