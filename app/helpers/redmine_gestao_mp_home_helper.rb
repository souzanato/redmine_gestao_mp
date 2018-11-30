module RedmineGestaoMpHomeHelper
	def welcome_message
		h = RDoc::Markup::ToHtml.new()
		message = File.open(Rails.root + "#{Rails.root}/plugins/redmine_gestao_mp/README.rdoc", 'r').read
		h.convert message
	end
end
