class CreateRedmineGestaoMpConfigs < ActiveRecord::Migration
  def change
    create_table :redmine_gestao_mp_configs do |t|

      t.string :name
      t.string :display_name
      t.string :scope
      t.string :value
      t.text :description
      t.belongs_to :project

      t.timestamps
    end

    add_index :redmine_gestao_mp_configs, :project_id
  end
end
