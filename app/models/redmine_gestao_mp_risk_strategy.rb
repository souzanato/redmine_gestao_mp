class RedmineGestaoMpRiskStrategy < ActiveRecord::Base
  unloadable

  belongs_to :redmine_gestao_mp_risk_type
  validates :code, uniqueness: {scope: :title}
  validates :code, :title, :redmine_gestao_mp_risk_type_id, presence: true
end
