class RedmineGestaoMpRisk < ActiveRecord::Base
  unloadable

  validates :title, 
  	:redmine_gestao_mp_risk_type_id, 
  	:redmine_gestao_mp_risk_probability_id, 
  	:redmine_gestao_mp_risk_impact_id, 
  	:redmine_gestao_mp_risk_strategy_id,
  	:project_id,
  presence: true

  validates :title, uniqueness: {scope: :project_id}

  belongs_to :redmine_gestao_mp_risk_type
  belongs_to :project
  belongs_to :redmine_gestao_mp_risk_strategy
  belongs_to :redmine_gestao_mp_risk_probability
  belongs_to :redmine_gestao_mp_risk_impact

  has_many :redmine_gestao_mp_risk_setups
  has_many :issues, through: :redmine_gestao_mp_risk_setups

  #  1 a  4 - Baixa
  #  5 a  9 - Média
  # 10 a 25 - Alta
  def criticality
    low_criticality_risk = RedmineGestaoMpConfig.find_by_name_and_scope_and_project_id(:low_criticality_risk, 'RedmineGestaoMpRisk', self.project.id)
    medium_criticality_risk = RedmineGestaoMpConfig.find_by_name_and_scope_and_project_id(:medium_criticality_risk, 'RedmineGestaoMpRisk', self.project.id)
    high_criticality_risk = RedmineGestaoMpConfig.find_by_name_and_scope_and_project_id(:high_criticality_risk, 'RedmineGestaoMpRisk', self.project.id)

    low_begin_rate = low_criticality_risk.value.split('-')[0].to_i
    medium_begin_rate = medium_criticality_risk.value.split('-')[0].to_i
    high_begin_rate = high_criticality_risk.value.split('-')[0].to_i

    val = self.redmine_gestao_mp_risk_probability.multiplier * self.redmine_gestao_mp_risk_impact.multiplier   
    return low_criticality_risk if val < medium_begin_rate
    return medium_criticality_risk if val > low_begin_rate and val < high_begin_rate
    return high_criticality_risk
  end

  def type_and_title
    "#{self.redmine_gestao_mp_risk_type.title} - #{self.title}"
  end

  def project_name
    self.project.identifier.upcase
  end
end
