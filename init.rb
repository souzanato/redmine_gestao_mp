# encoding: UTF-8
require 'redmine'
# require_dependency 'redmine_gestao_mp/include_javascripts_hook'
# require_dependency 'redmine_gestao_mp/include_stylesheets_hook'

ApplicationHelper.send(:include, RedmineGestaoMp::ApplicationHelperPatch)
Project.send(:include, RedmineGestaoMp::ProjectPatch)
User.send(:include, RedmineGestaoMp::UserPatch)


Redmine::Plugin.register :redmine_gestao_mp do
  name 'Plugin de Suporte à Gestão de Projetos do Ministério do Planejamento'
  author 'Renato de Souza'
  description 'Esse é um plugin redmine que conta com algumas funcionalidades de gestão adaptadas para a realidade do Ministério do Planejamento'
  version '0.0.1'
  url 'https://github.com/souzanato/redmine_gestao_mp'
  author_url 'https://www.linkedin.com/in/renatocdesouza/'

  menu :project_menu, :redmine_gestao_mp, { :controller => 'redmine_gestao_mp_home', :action => 'index' }, :caption => :redmine_gestao_mp, param: :project_id

  project_module :redmine_gestao_mp do
    permission :redmine_gestao_mp_view_home, {redmine_gestao_mp_home: [:index] }, :public => true
    permission :redmine_gestao_mp_view_issues, {redmine_gestao_mp_issues: [:index]}
  end

end

