class RedmineGestaoMpHomeController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project#, :authorize, :only => :index
  include ApplicationHelper

  def index
    unless can?(:create, :redmine_gestao_mp_config)
      flash[:warning] = t('redmine_gestao_mp_request_load_redmine_gestao_mp_configs') unless redmine_gestao_mp_config_loaded?      
    end

    if can?(:create, :redmine_gestao_mp_config)
      flash[:warning] = "#{(view_context.link_to t('redmine_gestao_mp_load_redmine_gestao_mp_configs'), project_redmine_gestao_mp_config_index_path(@project.identifier, load_config: true), method: :post)}  #{t('redmine_gestao_mp_to_start')}" unless redmine_gestao_mp_config_loaded?      
    end
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
