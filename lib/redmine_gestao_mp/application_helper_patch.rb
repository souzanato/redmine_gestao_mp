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
            {name: 'yellow_light', scope: 'Issue'},
            {name: 'high_criticality_risk', scope: 'RedmineGestaoMpRisk'},
            {name: 'medium_criticality_risk', scope: 'RedmineGestaoMpRisk'},
            {name: 'high_criticality_risk', scope: 'RedmineGestaoMpRisk'},
            {name: 'high_meter_risk', scope: 'RedmineGestaoMpRisk'},
            {name: 'medium_meter_risk', scope: 'RedmineGestaoMpRisk'},
            {name: 'low_meter_risk', scope: 'RedmineGestaoMpRisk'}
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

          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'high_criticality_risk', display_name: 'Alta', description: 'Riscos com criticidade alta, possuem o valor do Multiplicador do Impacto x Multiplicador da probabilidade entre 10 e 25', scope: 'RedmineGestaoMpRisk', value: '10-25')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'medium_criticality_risk', display_name: 'Média', description: 'Riscos com criticidade média, possuem o valor do Multiplicador do Impacto x Multiplicador da probabilidade entre 5 e 9', scope: 'RedmineGestaoMpRisk', value: '5-9')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'low_criticality_risk', display_name: 'Baixa', description: 'Riscos com criticidade baixa, possuem o valor do Multiplicador do Impacto x Multiplicador da probabilidade entre 1 e 4', scope: 'RedmineGestaoMpRisk', value: '1-4')  

          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'high_meter_risk', display_name: 'Alta', description: 'Range para cor vermelha do medidor de risco', scope: 'RedmineGestaoMpRisk', value: '67-100')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'medium_meter_risk', display_name: 'Média', description: 'Range para cor amarela do medidor de risco', scope: 'RedmineGestaoMpRisk', value: '34-66')  
          RedmineGestaoMpConfig.create(project_id: Project.find_by_identifier(params[:project_id]).id, name: 'low_meter_risk', display_name: 'Baixa', description: 'Range para cor branca do medidor de risco', scope: 'RedmineGestaoMpRisk', value: '0-33')  
        end

        def redmine_gestao_mp_risk_criticality_light(criticality)
          if criticality.name == 'low_criticality_risk'
            html =  "<span rel='#{criticality.description}' title='#{criticality.description}' class='redmine-gestao-mp-light green-light'></span>"
          elsif criticality.name == 'medium_criticality_risk'
            html = "<span rel='#{criticality.description}' title='#{criticality.description}' class='redmine-gestao-mp-light yellow-light'></span>"   
          else
            html = "<span rel='#{criticality.description}' title='#{criticality.description}' class='redmine-gestao-mp-light red-light'></span>"    
          end 

          html.html_safe
        end

        def redmine_gestao_mp_risk_project_display(risk, current_project)
          risk.project == current_project ? '-' : redmine_gestao_mp_link_to_project(risk.project)
        end

        def redmine_gestao_mp_link_to_project(project)
          link_to project.identifier, project_path(project)
        end
      end
    end
  end
end