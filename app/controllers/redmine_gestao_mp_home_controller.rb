class RedmineGestaoMpHomeController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project#, :authorize, :only => :index
  include ApplicationHelper

  def index
    unless can?(:create, :redmine_gestao_mp_config)
      flash[:warning] = t('redmine_gestao_mp_request_load_redmine_gestao_mp_configs') unless redmine_gestao_mp_config_loaded?
    end
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
