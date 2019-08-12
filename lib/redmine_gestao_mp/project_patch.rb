require_dependency 'project'
module RedmineGestaoMp
  module ProjectPatch
    def self.included(base)
      base.class_eval do

        # has_many :redmine_gestao_mp_risks
        has_many :redmine_gestao_mp_configs

        def parent_and_children(project = self, children = [self])
          project.children.each do |parent|
            children << parent
            parent_and_children(parent, children)
          end

          children
        end

        def filter_available_projects(projects)
          return projects if User.current.admin
          available_projects = User.current.memberships.collect(&:project).map{|p| p}
          projects.select{|p| available_projects.include?(p)}
        end

        def sort_target_array(cllction)
          cllction.sort{|a,b| 
            a.start_date && b.start_date ? a.start_date<=>b.start_date :
            a.start_date ? -1 : 1
          }
        end

        def parent_and_children_issues
          Issue.where(project_id: parent_and_children.map{|p| p.id})
        end

        def build_project_hierarchy(target_array = [], project_id = self.id)
          sort_target_array(filter_available_projects(self.parent_and_children)).select { |h| (h[:parent_id] == project_id) }.each do |h|
            target_array << {
              key: "P#{h.id}", 
              light: h.light[:color], 
              light_title: h.light[:title],
              start_date: h.start_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(h.start_date), 
              due_date: h.due_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(h.due_date), 
              title: "<a target='_blank' href='/projects/#{h[:identifier]}'>#{h[:name]}</a>", 
              expanded: false, 
              folder: true, 
              class_type: 'Project', 
              assigned_to: "", 
              children: build_project_hierarchy([], h[:id]) + build_issue_hierarchy([], nil, h)
            }
          end

          if self.parent_and_children.count == 1
            pandc = self.parent_and_children[0]
            target_array << {
              key: "P#{pandc.id}", 
              disabled: true, 
              light: pandc.light[:color], 
              light_title: pandc.light[:title],
              start_date: pandc.start_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(pandc.start_date), 
              due_date: pandc.due_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(pandc.due_date), 
              title: "<a target='_blank' href='/projects/#{pandc[:identifier]}' alt='#{pandc[:name]}' title='#{pandc[:name]}'>#{pandc[:name][0..50].gsub(/\s\w+$/,'...')}</a>", 
              expanded: false, 
              folder: true, 
              class_type: 'Project', 
              assigned_to: "", 
              children: build_issue_hierarchy([], nil, pandc)
            }
          end

          target_array
        end

        def build_issue_hierarchy(target_array = [], issue_id = nil, project = self)
          sort_target_array(project.parent_and_children_issues).select { |h| (h[:parent_id] == issue_id) }.each do |issue|
            target_array << {
              key: "I#{issue.id}", 
              disabled: !issue.leaf?, 
              light: issue.light[:color], 
              light_title: issue.light[:title],
              start_date: issue.start_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(issue.start_date), 
              due_date: issue.due_date.nil? ? I18n.t('redmine_gestao_mp_no_data_found') : I18n.l(issue.due_date), 
              title: "<a target='_blank' href='/issues/#{issue.id}' alt='#{issue.subject}' title='#{issue.subject}'>#{issue.subject[0..50].gsub(/\s\w+$/,'...')}</a>", 
              expanded: false, 
              folder: issue.children.any?, 
              assigned_to: issue.assigned_to.try(:name).nil? ? "" : issue.assigned_to.try(:name), 
              class_type: 'Issue', 
              children: build_issue_hierarchy([], issue.id)
            }
          end
          target_array
        end

        def light
          resolved_light = resolve_light
          return {color: resolved_light[:color], title: resolved_light[:title]}
        end  

        def resolve_light
          if self.due_date.nil? or self.due_date.blank? or !self.active?
            neutral_light =  RedmineGestaoMpConfig.where(
              name: 'gray_light', 
              project_id: self.project.hierarchy.map{|p| p.id}, 
              scope: 'Project')[0]
            
            return {color: :gray, title: "#{neutral_light.display_name} - #{neutral_light.description}"}            
          end

          days_left = (self.due_date - Date.today).to_i

          green_light = RedmineGestaoMpConfig.where(
            name: 'green_light', 
            project_id: self.hierarchy.map{|p| p.id}, 
            scope: 'Project')[0]
          return {color: :green, title: "#{green_light.display_name} - #{green_light.description}"} if days_left >= green_light.value.to_i

          yellow_light = RedmineGestaoMpConfig.where(
            name: 'yellow_light', 
            project_id: self.project.hierarchy.map{|p| p.id}, 
            scope: 'Issue')[0]
          return {color: :yellow, title: "#{yellow_light.display_name} - #{yellow_light.description}", description: yellow_light.description} if days_left < green_light.value.to_i and days_left > 0

          red_light = RedmineGestaoMpConfig.where(
            name: 'red_light', 
            project_id: self.hierarchy.map{|p| p.id}, 
            scope: 'Project')[0]
          return {color: :red, title: "#{red_light.display_name} - #{red_light.description}"}
        end

        def self_and_parents(project = self, parents = [self])
          if project.parent
            parents << project.parent
            self_and_parents(project.parent, parents)
          end

          parents
        end

        def self_and_parent_risks
          RedmineGestaoMpRisk.where(project_id: self_and_parents.map{|p| p.id})
        end

        def self_and_child_risks
          RedmineGestaoMpRisk.where(project_id: parent_and_children.map{|p| p.id})
        end

        # Retorna a maior criticidade presente dentre os riscos do projeto
        def criticality
          criticalities = self.self_and_child_risks.map{|r| r.criticality}

          return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :high_criticality_risk) if criticalities.select{|c| c.name == 'high_criticality_risk'}.any?
          return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :medium_criticality_risk) if criticalities.select{|c| c.name == 'medium_criticality_risk'}.any?
          return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :low_criticality_risk)
        end

        # Define a área do ponteiro do medidor de acordo com a criticidade. 
        # Os valores são ajustados na área de configuração.
        def meter_risk_area
          crit = criticality
          if crit.name == 'high_criticality_risk'
            return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :high_meter_risk)
          elsif crit.name == 'medium_criticality_risk'
            return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :medium_meter_risk)
          else
            return RedmineGestaoMpConfig.find_by_project_id_and_name(self.id, :low_meter_risk)
          end
        end

        # 1. É atribuido o valor 100 é para cada risco de um projeto
        # 2. Faz um somatório das porcentagens de conclusão de cada tarefa. 
        #    2.1 Se não existir tarefas associadas ao risco ele retorna o valor zero a este somatório
        #    2.2 Se a tarefa estiver fechada ele retorna o valor 100
        # 3. É realizado uma regra de tres entre o somatorio do item 2 e os valores atribuidos por projeto do item 1.
        # 4. O valor retornado é a porcentagem concluida.
        def risk_strategy_done
          total_count = 0
          total_done_ratio = 0
          
          self.self_and_child_risks.select{|r| r.criticality.name == criticality.name}.each do |risk|
            is = risk.issues
            if is.any?
              is.each do |issue|
                total_done_ratio = issue.closed? ? (total_done_ratio + 100) : (total_done_ratio + issue.done_ratio)
                total_count = total_count + 1
              end              
            end
          end

          unless total_count == 0 and total_done_ratio == 0
            final_done_ratio = (total_count*100) - total_done_ratio
            100 - (final_done_ratio * 100) / (total_count * 100)
          else
            return 0          
          end
        end

        def negative_risk_meter_value  
          rsd = risk_strategy_done
          risk_area = meter_risk_area.value

          # Retorna o valor maximo do medidor corrente caso haja algum risco com a estratégia Aceitar.          
          return risk_area.split('-')[1].to_i if self.self_and_child_risks.select{|r| r.redmine_gestao_mp_risk_strategy.treatable == false }.any?

          # Retorna o valor maximo do medidor corrente caso nenhuma tarefa associada a um risco apresente andamento          
          return risk_area.split('-')[1].to_i if rsd == 0
          
          converted_value = rsd == 100 ? risk_area.split('-')[1].to_i : (rsd * (risk_area.split('-')[1].to_i - risk_area.split('-')[0].to_i)) / 100
          risk_area.split('-')[1].to_i - converted_value
        end
      end
    end
  end
end
