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
            return false unless RedmineGestaoMpConfig.find_by_name(config)
          end

          true
        end

        def load_redmine_gestao_mp_config
          RedmineGestaoMpConfig.create(name: 'green_light', display_name: 'Sinal Verde', description: 'Tarefas em dia ficam com o sinal verde. O valor desta configuração representa a distancia máxima em dias para que a tarefa perca este sinal.', scope: 'Issue', value: '5')  
        end


      end
    end
  end
end