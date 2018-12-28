class CreateRedmineGestaoMpRiskStrategies < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_strategies do |t|

      t.string :code

      t.string :title

      t.text :description

      t.belongs_to :redmine_gestao_mp_risk_type

    end
    add_index :redmine_gestao_mp_risk_strategies, :redmine_gestao_mp_risk_type_id, name: 'index_rm_gestao_mp_risk_strat_on_rm_gestao_mp_risk_type_id'

  end
end
