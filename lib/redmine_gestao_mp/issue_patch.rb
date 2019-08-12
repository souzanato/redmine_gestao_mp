require_dependency 'issue'
module RedmineGestaoMp
  module IssuePatch
    def self.included(base)
      base.class_eval do

        has_many :redmine_gestao_mp_risk_setups
        # has_many :redmine_gestao_mp_risks, through: :redmine_gestao_mp_risk_setups

        def light
          resolved_light = resolve_light
          return {color: resolved_light[:color], title: resolved_light[:title]}
        end

        def resolve_light
          if self.due_date.nil? or self.due_date.blank?
            neutral_light =  RedmineGestaoMpConfig.where(
              name: 'gray_light', 
              project_id: self.project.hierarchy.map{|p| p.id}, 
              scope: 'Issue')[0]
            
            return {color: :gray, title: "#{neutral_light.display_name} - #{neutral_light.description}"}
          end
          
          days_left = (self.due_date - Date.today).to_i

          green_light = RedmineGestaoMpConfig.where(
            name: 'green_light', 
            project_id: self.project.hierarchy.map{|p| p.id}, 
            scope: 'Issue')[0]
          return {color: :green, title: "#{green_light.display_name} - #{green_light.description}"} if days_left >= green_light.value.to_i or status.is_closed?      

          yellow_light = RedmineGestaoMpConfig.where(
            name: 'yellow_light', 
            project_id: self.project.hierarchy.map{|p| p.id}, 
            scope: 'Issue')[0]
          return {color: :yellow, title: "#{yellow_light.display_name} - #{yellow_light.description}", description: yellow_light.description} if days_left < green_light.value.to_i and days_left > 0

          red_light = RedmineGestaoMpConfig.where(
            name: 'red_light', 
            project_id: self.project.hierarchy.map{|p| p.id}, 
            scope: 'Issue')[0]
          return {color: :red, title: "#{red_light.display_name} - #{red_light.description}", description: red_light.description}
        end
   
      end
    end
  end
end
