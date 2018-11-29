module RedmineGestaoMp
	module Hooks

	  class IncludeStylesheetsHook < Redmine::Hook::ViewListener
	    include ActionView::Helpers::TagHelper

	    def view_layouts_base_html_head(context)
	      stylesheet_link_tag('application', :plugin => 'redmine_gestao_mp')
	    end
	  end

	end
end
