class CreateRedmineGestaoMpRiskProbabilities < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_probabilities do |t|

      t.string :code

      t.string :title

      t.integer :multiplier

    end

  end
end
