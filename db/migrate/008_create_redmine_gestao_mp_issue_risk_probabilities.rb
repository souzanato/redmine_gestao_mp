class CreateRedmineGestaoMpIssueRiskProbabilities < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_issue_risk_probabilities do |t|

      t.belongs_to :issue

      t.belongs_to :redmine_gestao_mp_risk

      t.belongs_to :redmine_gestao_mp_risk_probability


    end

    add_index :redmine_gestao_mp_issue_risk_probabilities, :issue_id, name: 'index_rm_gmp_issue_risk_probabilities_on_rm_gmp_risk_id'

    add_index :redmine_gestao_mp_issue_risk_probabilities, :redmine_gestao_mp_risk_id, name: 'index_rm_gmp_risk_risk_probabilities_on_rm_gmp_risk_id'

    add_index :redmine_gestao_mp_issue_risk_probabilities, :redmine_gestao_mp_risk_probability_id, name: 'index_rm_gmp_risk_prob_risk_probabilities_on_rm_gmp_risk_id'

  end
end
