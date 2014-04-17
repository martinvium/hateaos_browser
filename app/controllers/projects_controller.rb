class ProjectsController < ApplicationController
  before_action :load_project, only: [:show]
  
  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/:project_id
  def show
  end
end
