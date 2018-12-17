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
          configs = ['green_light']
          configs.each do |config|
            return false unless RedmineGestaoMpConfig.find_by_name_and_project_id(config, Project.find_by_identifier(params[:project_id]).id)
          end

          true
        end

        def load_redmine_gestao_mp_config
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'green_light', display_name: 'Sinal Verde', description: 'Se a distancia entre a data atual e o prazo de entrega for maior ou igual (em dias) ao valor estabelecido na configuração, a tarefa ou projeto está com sinal verde.', scope: 'Issue', value: '5')  
        end


      end
    end
  end
end