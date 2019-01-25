class CreateRedmineGestaoMpIssueRiskImpacts < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_issue_risk_impacts do |t|

      t.belongs_to :issue

      t.belongs_to :redmine_gestao_mp_risk

      t.belongs_to :redmine_gestao_mp_risk_impact


    end

    add_index :redmine_gestao_mp_issue_risk_impacts, :issue_id

    add_index :redmine_gestao_mp_issue_risk_impacts, :redmine_gestao_mp_risk_id, name: 'index_rm_gmp_issue_risk_impacts_on_rm_gmp_risk_id'

    add_index :redmine_gestao_mp_issue_risk_impacts, :redmine_gestao_mp_risk_impact_id, name: 'index_rm_gmp_issue_risk_impact_impacts_on_rm_gmp_risk_id'

  end
end
