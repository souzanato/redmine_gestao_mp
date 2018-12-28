require_dependency 'application_helper'
module RedmineGestaoMp
  module ApplicationHelperPatch
    def self.included(base)
      base.class_eval do
        def can?(action, controller, project = @project)
          User.current.allowed_to?({controller: controller, :action => action}, project)
        end

        def l(object, options = {})
          super(object, options) if object
        end

        def redmine_gestao_mp_config_loaded?
          configs = [
            {name: 'green_light', scope: 'Project'},
            {name: 'red_light', scope: 'Project'},
            {name: 'gray_light', scope: 'Project'},
            {name: 'green_light', scope: 'Issue'},
            {name: 'red_light', scope: 'Issue'},
            {name: 'gray_light', scope: 'Issue'},
            {name: 'yellow_light', scope: 'Issue'}
          ]
          configs.each do |config|
            return false unless RedmineGestaoMpConfig.find_by_name_and_project_id_and_scope(config[:name], Project.find_by_identifier(params[:project_id]).id, config[:scope])
          end

          true
        end

        def load_redmine_gestao_mp_config
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'green_light', display_name: 'Sinal Verde', description: 'Tarefas fechadas ou em andamento com 5 ou mais dias da data prevista', scope: 'Issue', value: '5')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'yellow_light', display_name: 'Sinal Amarelo', description: 'Tarefas em andamento com menos de 5 dias da data prevista', scope: 'Issue', value: 'Não se Aplica')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'red_light', display_name: 'Sinal Vermelho', description: 'Tarefas em andamento e atrasadas', scope: 'Issue', value: 'Não se Aplica')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'gray_light', display_name: 'Sinal Cinza', description: 'Tarefas com data de início e/ou data prevista em branco', scope: 'Issue', value: 'Não se Aplica')  

          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'green_light', display_name: 'Sinal Verde', description: 'Projetos ativos com 5 ou mais dias da data prevista', scope: 'Project', value: '5')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'red_light', display_name: 'Sinal Vermelho', description: 'Projetos inativos e/ou atrasados.', scope: 'Project', value: 'Não se Aplica')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'gray_light', display_name: 'Sinal Cinza', description: 'Projetos com data de início e/ou data prevista em branco ou inativos', scope: 'Project', value: 'Não se Aplica')  
        end


      end
    end
  end
end