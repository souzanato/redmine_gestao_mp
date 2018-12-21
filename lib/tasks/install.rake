namespace :redmine do
	namespace :plugins do
		namespace :redmine_gestao_mp do
			desc 'Redmine Gestao MP Install'
			task install: :environment do |t|
				puts "\nConfigurando migrations e assets...".bold
				system("RAILS_ENV=#{Rails.env} rake redmine:plugins")
				puts "Feito!".green

				puts "\nConfigurando Permissões para os perfis de Gerente, Desenvolvedor e Usuario Cliente...".bold
				Role.find(3).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_issues,
					:redmine_gestao_mp_view_config,
					:redmine_gestao_mp_create_config,
					:redmine_gestao_mp_edit_config
				)

				Role.find(4).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_issues
				)

				Role.find(7).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_issues
				)
				puts "Feito!".green

				puts "\nPlugin configurado com sucesso".bold
				puts "Solicite a um administrador a configuração de permissões do módulo Gestão MP a outros perfis."
				puts "\n\n"

			end
		end
	end
end
