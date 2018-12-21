## Gestão MP
<b>Plugin Redmine para suporte na Gestão de Projetos do Ministério do Planejamento</b>


Esse é um plugin redmine que conta com algumas funcionalidades de gestão adaptadas para a realidade do Ministério do Planejamento.

<b>Instalação</b>
```shell
# Na pasta raiz do redmine
cd plugins
git clone https://github.com/souzanato/redmine_gestao_mp.git
git checkout tags/v0.0.1

# De volta à pasta raiz do redmine
bundle install && RAILS_ENV=<development|production> rake redmine:plugins:redmine_gestao_mp:install

# Reiniciar o servidor WEB
```
