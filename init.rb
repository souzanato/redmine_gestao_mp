# encoding: UTF-8
require 'redmine'
require 'active_record/connection_adapters/mysql2_adapter'
require_dependency 'redmine_gestao_mp/inflections'
require_dependency 'redmine_gestao_mp/hooks'

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
    permission :redmine_gestao_mp_view_issues, {
      redmine_gestao_mp_issues: [:index],
      redmine_gestao_mp_risk_issues: [:index]
    }
    
    ### Configurações ###
    # Ver #
    permission :redmine_gestao_mp_view_config, {redmine_gestao_mp_config: [:index, :show]}
    # Criar #
    permission :redmine_gestao_mp_create_config, {redmine_gestao_mp_config: [:new, :create]}
    # Editar #
    permission :redmine_gestao_mp_edit_config, {redmine_gestao_mp_config: [:edit, :update]}
    # Destruir #
    # permission :redmine_gestao_mp_destroy_config, {redmine_gestao_mp_config: [:destroy]}   

    ### Riscos ###
    # Ver #
    # permission :redmine_gestao_mp_view_risks, {redmine_gestao_mp_risks: [:index, :show]}
    # Criar #
    # permission :redmine_gestao_mp_create_risks, {redmine_gestao_mp_risks: [:new, :create], redmine_gestao_mp_risk_strategies: [:index]}
    # Editar #
    # permission :redmine_gestao_mp_edit_risks, {redmine_gestao_mp_risks: [:edit, :update], redmine_gestao_mp_risk_strategies: [:index]}
    # Destruir #
    # permission :redmine_gestao_mp_destroy_risks, {redmine_gestao_mp_risks: [:destroy]}

    ### Configuração de Riscos ###
    # Ver #
    # permission :redmine_gestao_mp_view_risk_setups, {redmine_gestao_mp_risk_setups: [:index, :show]}
    # Criar #
    # permission :redmine_gestao_mp_create_risk_setups, {redmine_gestao_mp_risk_setups: [:new, :create], redmine_gestao_mp_risk_strategies: [:index]}
    # Editar #
    # permission :redmine_gestao_mp_edit_risk_setups, {redmine_gestao_mp_risk_setups: [:edit, :update], redmine_gestao_mp_risk_strategies: [:index]}
    # Destruir #
    # permission :redmine_gestao_mp_destroy_risk_setups, {redmine_gestao_mp_risk_setups: [:destroy]}
  end

end

