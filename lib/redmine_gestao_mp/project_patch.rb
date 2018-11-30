require_dependency 'project'
module RedmineGestaoMp
  module ProjectPatch
    def self.included(base)
      base.class_eval do

        def parent_and_children(project = self, children = [self])
          project.children.each do |parent|
            children << parent
            parent_and_children(parent, children)
          end

          return children if User.current.admin
          available_projects = User.current.memberships.collect(&:project).map{|p| p}
          children.select{|p| available_projects.include?(p)}.sort{|a,b| a.created_on<=>b.created_on}
        end

        def parent_and_children_issues
          Issue.where(project_id: parent_and_children.map{|p| p.id}).sort{|a,b| a.created_on<=>b.created_on}
        end

        def build_project_hierarchy(target_array = [], project_id = self.id)
          self.parent_and_children.select { |h| (h[:parent_id] == project_id) }.each do |h|
            target_array << {key: "P#{h.id}", start_date: h.start_date.nil? ? 'Sem Registro' : I18n.l(h.start_date), due_date: h.due_date.nil? ? 'Sem registro' : I18n.l(h.due_date), title: h[:name], expanded: false, folder: true, class_type: 'Project', children: build_project_hierarchy([], h[:id]) + build_issue_hierarchy([], nil, h)}
          end
          target_array
        end

        def build_issue_hierarchy(target_array = [], issue_id = nil, project = self)
          project.parent_and_children_issues.select { |h| (h[:parent_id] == issue_id) }.each do |issue|
            target_array << {key: "I#{issue.id}",start_date: issue.start_date.nil? ? 'Sem Registro' : I18n.l(issue.start_date), due_date: issue.due_date.nil? ? 'Sem registro' : I18n.l(issue.due_date), title: issue.subject, expanded: false, folder: issue.children.any?, class_type: 'Issue', children: build_issue_hierarchy([], issue.id)}
          end
          target_array
        end

    

      end
    end
  end
end
