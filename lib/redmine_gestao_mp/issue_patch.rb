require_dependency 'issue'
module RedmineGestaoMp
  module IssuePatch
    def self.included(base)
      base.class_eval do
        def light
          return :neutral if self.due_date.nil? or self.due_date.blank?

          green_light_val = RedmineGestaoMpConfig.where(
            name: 'green_light', 
            project_id: self.project.hierarchy.map{|p| p.id}, 
            scope: 'Issue')[0].value.to_i

          days_left = (self.due_date - Date.today).to_i

          return :green if days_left >= green_light_val or !self.overdue?
          return :warning if days_left < green_light_val and days_left > 0
          return :danger
        end
   
      end
    end
  end
end
