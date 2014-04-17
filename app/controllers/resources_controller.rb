class ResourcesController < ApplicationController
  before_action :load_project
  before_action :load_uri

  # GET /projects/1/resource/get?uri=
  def get
    @resource = @project.get(@uri)
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

  def client
    
  end

  def load_uri
    if params[:uri].present?
      @uri = params[:uri]
    else
      @uri = @project.url
    end
  end
end