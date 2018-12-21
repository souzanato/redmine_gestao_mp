# encoding: UTF-8
require 'redmine'
require 'active_record/connection_adapters/mysql2_adapter'

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end

ApplicationController.send(:include, RedmineGestaoMp::ApplicationControllerPatch)
ApplicationHelper.send(:include, RedmineGestaoMp::ApplicationHelperPatch)
Project.send(:include, RedmineGestaoMp::ProjectPatch)
Issue.send(:include, RedmineGestaoMp::IssuePatch)
User.send(:include, RedmineGestaoMp::UserPatch)

Redmine::Plugin.register :redmine_gestao_mp do
  name 'Plugin Redmine para suporte na Gestão de Projetos do Ministério do Planejamento'
  author 'Renato de Souza'
  description 'Plugin Redmine para suporte na Gestão de Projetos do Ministério do Planejamento'
  version '0.0.1'
  url 'https://github.com/souzanato/redmine_gestao_mp'
  author_url 'https://www.linkedin.com/in/renatocdesouza/'

  menu :project_menu, :redmine_gestao_mp, { :controller => 'redmine_gestao_mp_home', :action => 'index' }, :caption => :redmine_gestao_mp, param: :project_id

  project_module :redmine_gestao_mp do
    ### Pagina inicial ###
    permission :redmine_gestao_mp_view_home, {redmine_gestao_mp_home: [:index] }
    
    ### Tarefas ###
    permission :redmine_gestao_mp_view_issues, {redmine_gestao_mp_issues: [:index]}
    
    ### Configurações ###
    # Ver #
    permission :redmine_gestao_mp_view_config, {redmine_gestao_mp_config: [:index, :show]}
    # Criar #
    permission :redmine_gestao_mp_create_config, {redmine_gestao_mp_config: [:new, :create]}
    # Editar #
    permission :redmine_gestao_mp_edit_config, {redmine_gestao_mp_config: [:edit, :update]}
    # Destruir #
    # permission :redmine_gestao_mp_destroy_config, {redmine_gestao_mp_config: [:destroy]}   
  end

end

