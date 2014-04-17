class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :user_token, :user_signed_in?

  def home
  end

  def user_signed_in?
    session[@project.id].present? and session[@project.id][:access_token].present?
  end

  def user_token
    session[@project.id][:access_token]
  end

  def authenticate_user!
    return if @project.nil?
    redirect_to login_path(@project)
  end

  def load_project
    @project = Project.find(params[:project_id])
    @project.oauth2_access_token = user_token if user_signed_in?
  end
end
