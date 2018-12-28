class CreateRedmineGestaoMpRiskImpacts < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_impacts do |t|

      t.string :code

      t.string :title

      t.integer :multiplier
    end

  end
end
