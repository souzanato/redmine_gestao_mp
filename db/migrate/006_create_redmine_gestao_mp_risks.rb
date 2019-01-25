class CreateRedmineGestaoMpRisks < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_risks do |t|

      t.string :title

      t.text :description

      t.belongs_to :redmine_gestao_mp_risk_type

      t.belongs_to :project

    end

    add_index :redmine_gestao_mp_risks, :redmine_gestao_mp_risk_type_id

    add_index :redmine_gestao_mp_risks, :project_id
  end
end
