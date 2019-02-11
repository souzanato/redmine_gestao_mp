class RedmineGestaoMpConfigController < ApplicationController
  unloadable
  include ApplicationHelper
  menu_item :redmine_gestao_mp
  before_filter :find_project, :authorize
  before_filter :set_redmine_gestao_mp_config, only: [:show, :edit, :update, :destroy]

  def index
    @redmine_gestao_mp_configs = RedmineGestaoMpConfig.where(project_id: @project.id)
    @config_scopes = RedmineGestaoMpConfig.all.uniq{|c| c.scope}.map{|s| s.scope.pluralize.underscore}
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
    elsif params[:reset].present?
      @project.redmine_gestao_mp_configs.destroy_all
      load_redmine_gestao_mp_config

      flash[:notice] = t('redmine_gestao_mp_message_project_configs_successfully_reseted')
      respond_to do |format|
        format.html {redirect_to :back}
      end      
    end
  end


  def edit    
  end


  def update
    respond_to do |format|
      if @redmine_gestao_mp_config.update_attributes(params[:redmine_gestao_mp_config])
        flash[:notice] = t('redmine_gestao_mp_config_successfully_updated')
        format.html {redirect_to project_redmine_gestao_mp_config_index_path(@project, tab: params[:tab])}
      else
        flash[:notice] = t('redmine_gestao_mp_config_unsuccessfully_updated')      
        format.html { render :edit }
      end
    end
  end


  def destroy
  end


  private

  def set_redmine_gestao_mp_config
    @redmine_gestao_mp_config = RedmineGestaoMpConfig.find(params[:id])
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
