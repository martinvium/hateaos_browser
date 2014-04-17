class ResourcesController < ApplicationController
  before_action :load_project
  before_action :load_url
  before_action :verify_url, except: [:bad_url]

  # GET /projects/1/resource/get?url=
  def get
    @resource = @project.get(@url)
  end

  # POST /projects/1/resource/post?url=
  def post
  end

  # PUT /projects/1/resource/put?url=
  def put
  end

  # DELETE /projects/1/resource/delete?url=
  def delete
  end

  def url_error
  end

private

  def verify_url
    if @project.url_placeholders?(@url)
      render action: "url_error"
    else
      begin
        URI(@url)
      rescue URI::InvalidURIError
        render action: "url_error"
      end
    end
  end

  def load_url
    if params[:url].present?
      @url = params[:url]
    else
      @url = @project.root_url
    end
  end
end