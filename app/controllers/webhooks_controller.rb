class WebhooksController < ApplicationController
  def create
    json = JSON.parse params[:payload]
    @status = Status.find_or_initialize_by_project_id(json["repository"]["id"])
    @status.project_name = json["repository"]["name"]
    @status.status_code  = json["status"]
    @status.save!
    head :ok
  end
end
