require_dependency 'issue'
module RedmineGestaoMp
  module IssuePatch
    def self.included(base)
      base.class_eval do
        def light
          return :neutral if self.due_date.nil? or self.due_date.blank?

          green_light_val = RedmineGestaoMpConfig.find_by_name('green_light').value.to_i
          days_left = (self.due_date - Date.today).to_i

          return :green if days_left >= green_light_val
          return :warning if days_left < green_light_val and days_left > 0
          return :danger
        end
   
      end
    end
  end
end
