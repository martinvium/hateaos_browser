class SessionsController < ApplicationController
  before_action :load_project, except: [:destroy]

  # GET /auth/:project_id
  def new
    redirect_to @project.authorize_url
  end

  # GET /auth/:project_id/callback
  def create
    access_token = @project.get_access_token(params[:code])
    redirect_to :action => :failure if access_token.blank?
    session[@project.id] = { access_token: access_token }
    redirect_to get_project_resource_path(@project)
  end

  # GET /logout
  def destroy
    reset_session
    redirect_to projects_path
  end

  def failure
    
  end

private

  def load_project
    @project = Project.find(params[:project_id])
  end
end