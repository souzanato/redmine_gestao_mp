class CreateRedmineGestaoMpRiskCountermeasures < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_countermeasures do |t|

      t.belongs_to :redmine_gestao_mp_risk

      t.belongs_to :redmine_gestao_mp_strategy

      t.belongs_to :issue


    end

    add_index :redmine_gestao_mp_risk_countermeasures, :redmine_gestao_mp_risk_id, name: 'index_rmgmp_risk_countermeasures_on_rmgmp_risk_id'

    add_index :redmine_gestao_mp_risk_countermeasures, :redmine_gestao_mp_strategy_id, name: 'index_rmgmp_risk_countermeasures_on_rmgmp_strategy_id'

    add_index :redmine_gestao_mp_risk_countermeasures, :issue_id, name: 'index_rmgmp_risk_countermeasures_on_issue_id'

  end
end
