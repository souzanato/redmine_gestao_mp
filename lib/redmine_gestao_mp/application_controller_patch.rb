require_dependency 'application_controller'
module RedmineGestaoMp
  module ApplicationControllerPatch
    def self.included(base)
      base.class_eval do
        include ApplicationHelper

        before_filter :check_redmine_gestao_mp_config
        def check_redmine_gestao_mp_config
          if controller_name.include?('redmine_gestao_mp')
            unless redmine_gestao_mp_config_loaded? or (action_name == 'index' and controller_name == 'redmine_gestao_mp_home') or (action_name == 'create' and controller_name == 'redmine_gestao_mp_config')
              redirect_to redmine_gestao_mp_home_path              
            end
          end
        end
      end
    end
  end
end