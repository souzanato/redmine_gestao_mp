class RedmineGestaoMpConfigController < ApplicationController
  unloadable
  include ApplicationHelper
  menu_item :redmine_gestao_mp
  before_filter :find_project, :authorize

  def index
  end


  def show
  end


  def new
  end


  def create
    if params[:load_config].present?  
      load_redmine_gestao_mp_config

      flash[:notice] = t('redmine_gestao_mp_youre_ready_to_start')
      respond_to do |format|
        format.html {redirect_to :back}
      end
    end
  end


  def edit
  end


  def update
  end


  def destroy
  end


  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
