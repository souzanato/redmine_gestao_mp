# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:project_id/gestao_mp', :to => 'redmine_gestao_mp_home#index', as: :redmine_gestao_mp_home
get '/projects/:project_id/gestao_mp/issues', :to => 'redmine_gestao_mp_issues#index', as: :redmine_gestao_mp_issues

resources :projects do
	resources :redmine_gestao_mp_config, path: 'gestao_mp/configs'
end