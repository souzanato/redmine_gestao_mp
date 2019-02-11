class RedmineGestaoMpRiskIssuesController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project, :find_risk, :authorize

  def index
  	@issues = @risk.issues

  	respond_to do |format|
  		format.js 
  	end
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end

  def find_risk
    # @project variable must be set before calling the authorize filter
    @risk = RedmineGestaoMpRisk.find(params[:redmine_gestao_mp_risk_id])
  end
end
