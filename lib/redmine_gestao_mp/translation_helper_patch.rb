require_dependency 'action_view/helpers/translation_helper'
module RedmineGestaoMp
  module TranslationHelperPatch
    def self.included(base)
      base.class_eval do
        def localize(*args)
         #Avoid I18n::ArgumentError for nil values
         I18n.localize(*args) unless args.first.nil?
        end
        # l() still points at old definition
        alias l localize
      end
    end
  end
end