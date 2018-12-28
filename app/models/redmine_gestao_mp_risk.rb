class RedmineGestaoMpRisk < ActiveRecord::Base
  unloadable

  validates :title, 
  	:redmine_gestao_mp_risk_type_id, 
  	:redmine_gestao_mp_risk_probability_id, 
  	:redmine_gestao_mp_risk_impact_id,
  	:project_id,
  presence: true

  belongs_to :redmine_gestao_mp_risk_type
  belongs_to :redmine_gestao_mp_risk_probability
  belongs_to :redmine_gestao_mp_risk_impact
  belongs_to :project
end
