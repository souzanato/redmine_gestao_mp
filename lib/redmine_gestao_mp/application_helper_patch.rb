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
            {name: 'green_light', scope: 'Issue'},
            {name: 'red_light', scope: 'Issue'},
            {name: 'yellow_light', scope: 'Issue'}
          ]
          configs.each do |config|
            return false unless RedmineGestaoMpConfig.find_by_name_and_project_id_and_scope(config[:name], Project.find_by_identifier(params[:project_id]).id, config[:scope])
          end

          true
        end

        def load_redmine_gestao_mp_config
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'green_light', display_name: 'Sinal Verde', description: 'Tarefas em dia ou fechadas. A data prevista menos o valor em dias deve ser maior ou igual que a data atual.', scope: 'Issue', value: '5')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'yellow_light', display_name: 'Sinal Amarelo', description: 'Tarefas não fechadas próximas da data prevista.', scope: 'Issue', value: 'Não se Aplica')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'red_light', display_name: 'Sinal Vermelho', description: 'Tarefas não fechadas que extrapolam a data prevista.', scope: 'Issue', value: 'Não se Aplica')  

          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'green_light', display_name: 'Sinal Verde', description: 'Projetos ativos e em dia.', scope: 'Project', value: 'Não se Aplica')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'red_light', display_name: 'Sinal Vermelho', description: 'Projetos inativos e/ou atrasados.', scope: 'Project', value: 'Não se Aplica')  
        end


      end
    end
  end
end