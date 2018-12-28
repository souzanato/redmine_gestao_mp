class RedmineGestaoMpIssuesController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project, :authorize, :only => :index

  def index
    if params[:jason_hierarchy].present?
      respond_to do |format|
        format.json {render json: @project.build_project_hierarchy.to_json}
      end      
    end    
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
