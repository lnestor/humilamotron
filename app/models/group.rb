class Group < ApplicationRecord
  has_many :liked_messages

  validates :groupme_id, :name, presence: true

  class << self
    def get_info_from_groupme(id)
      raw_response = Faraday.get(groups_url(id))
      JSON.parse(raw_response.body, symbolize_names: true)
    end

    private

    def groups_url(id)
      "https://api.groupme.com/v3/groups/#{id}?access_token=#{ENV['GROUPME_ACCESS_TOKEN']}"
    end
  end
end
