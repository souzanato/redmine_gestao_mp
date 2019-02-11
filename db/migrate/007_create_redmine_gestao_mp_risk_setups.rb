class CreateRedmineGestaoMpRiskSetups < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_setups do |t|
      t.belongs_to :redmine_gestao_mp_risk
      t.belongs_to :issue
    end

    add_index :redmine_gestao_mp_risk_setups, :redmine_gestao_mp_risk_id
    add_index :redmine_gestao_mp_risk_setups, :issue_id
  end
end
