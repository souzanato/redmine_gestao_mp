namespace :redmine do
	namespace :plugins do
		namespace :redmine_gestao_mp do
			desc 'Redmine Gestao MP Install'
			task install: :environment do |t|
				puts "\nConfigurando migrations...".bold
				system("RAILS_ENV=#{Rails.env} rake redmine:plugins:migrate")

				puts "\nConfigurando gems...".bold
				system("bundle exec gem install active_link_to")
				system("bundle exec gem install colored")

				puts "\nConfigurando assets...".bold
				system("RAILS_ENV=#{Rails.env} rake redmine:plugins:assets")

				puts "\n\n"
				puts "Plugin configurado com sucesso".bold
				puts "Solicite a um administrador a configuração dos perfis e permissões para o módulo Gestão MP."
				puts "\n\n"

			end
		end
	end
end
