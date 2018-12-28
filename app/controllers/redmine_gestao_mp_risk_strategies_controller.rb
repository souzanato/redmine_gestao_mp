class RedmineGestaoMpRiskStrategiesController < ApplicationController
  unloadable
  menu_item :redmine_gestao_mp
  before_filter :find_project, :authorize
  before_filter :set_redmine_gestao_mp_risk, only: [:show, :edit, :update, :destroy]

  def index
    if params[:redmine_gestao_mp_risk_type_id].present?
      unless params[:redmine_gestao_mp_risk_type_id] == '0'
        risk_strategies = RedmineGestaoMpRiskStrategy.where(redmine_gestao_mp_risk_type_id: params[:redmine_gestao_mp_risk_type_id])  
        respond_to do |format|
          format.json {render json: risk_strategies.map{|s| s.attributes}.unshift({id: "", title: t('redmine_gestao_mp_select_prompt')}) }
        end
      else
        respond_to do |format|
          format.json {render json: [{id: "", title: t('redmine_gestao_mp_risks_select_risk_type_prompt')}]}
        end              
      end
    end    
  end

  def show
  end

  def new
    @risk = RedmineGestaoMpRisk.new
  end

  def create
  end


  def edit    
  end


  def update
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
