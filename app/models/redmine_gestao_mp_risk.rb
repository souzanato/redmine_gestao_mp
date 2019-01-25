class RedmineGestaoMpRisk < ActiveRecord::Base
  unloadable

  validates :title, 
  	:redmine_gestao_mp_risk_type_id, 
  	:project_id,
  presence: true

  validates :title, uniqueness: {scope: :project_id}

  belongs_to :redmine_gestao_mp_risk_type
  belongs_to :project
end
