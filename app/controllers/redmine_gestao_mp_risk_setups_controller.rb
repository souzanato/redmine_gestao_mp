class RedmineGestaoMpRiskSetupsController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project, :find_issue, :authorize
  before_filter :set_redmine_gestao_mp_risk_setup, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new    
    @redmine_gestao_mp_risk_setup = RedmineGestaoMpRiskSetup.new
    @project_parent_risks = @project.self_and_parent_risks.reject{|r| @issue.redmine_gestao_mp_risks.include?(r)}
    
    respond_to do |format|
      format.js
    end
  end

  def create
    @redmine_gestao_mp_risk_setup = RedmineGestaoMpRiskSetup.new(params[:redmine_gestao_mp_risk_setup])
    @redmine_gestao_mp_risk_setup.issue_id = params[:issue_id]
    @redmine_gestao_mp_risk_setup.save
    
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @redmine_gestao_mp_risk_setup.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_redmine_gestao_mp_risk_setup
    @redmine_gestao_mp_risk_setup = RedmineGestaoMpRiskSetup.find(params[:id])
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end

  def find_issue
    # @project variable must be set before calling the authorize filter
    @issue = Issue.find(params[:issue_id])
  end
end
