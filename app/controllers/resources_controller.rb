require 'rest-client'

class ResourcesController < ApplicationController
  before_action :load_project
  before_action :load_uri

  # GET /projects/1/resource/get?uri=
  def get
    @response = RestClient.get @uri
    parsed = ActiveSupport::JSON.backend.load(@response.body)
    @links = parsed
  end

  # POST /projects/1/resource/post?uri=
  def post
    
  end

  # PUT /projects/1/resource/put?uri=
  def put
    
  end

  # DELETE /projects/1/resource/delete?uri=
  def delete
    
  end

  private

  def load_uri
    if params[:uri].present?
      @uri = params[:uri]
    else
      @uri = @project.root
    end
  end

  def load_project
    @project = Project.find(params[:project_id])
  end
end