class RedmineGestaoMpRisksController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project, :authorize
  before_filter :set_redmine_gestao_mp_risk, only: [:show, :edit, :update, :destroy]

  def index
    @redmine_gestao_mp_risks = RedmineGestaoMpRisk.where(project_id: @project.parent_and_children.map{|p| p.id})
    @risks_by_type = @redmine_gestao_mp_risks.group_by{|r| r.redmine_gestao_mp_risk_type}     

    @high_start = RedmineGestaoMpConfig.where(project_id: @project.id, name: 'high_meter_risk')[0]
    @medium_start = RedmineGestaoMpConfig.where(project_id: @project.id, name: 'medium_meter_risk')[0]
    @low_start = RedmineGestaoMpConfig.where(project_id: @project.id, name: 'low_meter_risk')[0]  

  end

  def show
    if params[:redmine_gestao_mp_risk_form_details].present?
      render partial: 'risk_show_table', locals: {risk: @redmine_gestao_mp_risk}
    end
  end

  def new
    @redmine_gestao_mp_risk = RedmineGestaoMpRisk.new
  end

  def create
    @redmine_gestao_mp_risk = RedmineGestaoMpRisk.new(params[:redmine_gestao_mp_risk])
    @redmine_gestao_mp_risk.project_id = @project.id

    respond_to do |format|
      if @redmine_gestao_mp_risk.save
        format.html { redirect_to project_redmine_gestao_mp_risk_path(@project, @redmine_gestao_mp_risk) }
        format.api  { render :action => 'show', :status => :created, :location => project_redmine_gestao_mp_risk_path(@project, @redmine_gestao_mp_risk) }
      else
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@risk) }
      end
    end     

  end


  def edit    
  end


  def update
    respond_to do |format|
      if @redmine_gestao_mp_risk.update_attributes(params[:redmine_gestao_mp_risk])
        format.html { redirect_to project_redmine_gestao_mp_risk_path(@project, @redmine_gestao_mp_risk) }
        format.api  { render :action => 'show', :status => :created, :location => project_redmine_gestao_mp_risk_path(@project, @redmine_gestao_mp_risk) }
      else
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@risk) }
      end
    end     
  end


  def destroy
  end


  private

  def set_redmine_gestao_mp_risk
    @redmine_gestao_mp_risk = RedmineGestaoMpRisk.find(params[:id])
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find_by_identifier(params[:project_id])
  end
end
