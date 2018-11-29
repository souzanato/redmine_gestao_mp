module RedmineGestaoMp
	module Hooks

	  class IncludeJavascriptsHook < Redmine::Hook::ViewListener
	    include ActionView::Helpers::TagHelper

	    def view_layouts_base_html_head(context)
	      javascript_include_tag('application', :plugin => 'redmine_gestao_mp')
	    end
	  end

	end
end
