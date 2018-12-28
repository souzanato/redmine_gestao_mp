class CreateRedmineGestaoMpRiskTypes < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risk_types do |t|

      t.string :code

      t.string :title

      t.text :description


    end

  end
end
