require_dependency 'user'
module RedmineGestaoMp
  module UserPatch
    def self.included(base)
      base.class_eval do

        # Returns user's membership for the given project
        # or nil if the user is not a member of project
        def membership(project)
          project_id = project.is_a?(Project) ? project.id : project

          @membership_by_project_id ||= Hash.new {|h, project_id|
            h[project_id] = memberships.where(:project_id => project_id)[0]
          }
          @membership_by_project_id[project_id]
        end

        def to_admin
          self.admin = true
          save
        end

        def to_not_admin
          self.admin = false
          save
        end

      end
    end
  end
end
