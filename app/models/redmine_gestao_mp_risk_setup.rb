class RedmineGestaoMpRiskSetup < ActiveRecord::Base
  unloadable
  belongs_to :redmine_gestao_mp_risk
  belongs_to :issue

  validates :redmine_gestao_mp_risk_id, :issue_id, presence: true
end
