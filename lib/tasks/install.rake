namespace :redmine do
	namespace :plugins do
		namespace :redmine_gestao_mp do
			desc 'Redmine Gestao MP Install'
			task install: :environment do |t|
				puts "\nConfigurando migrations e assets...".bold
				system("RAILS_ENV=#{Rails.env} rake redmine:plugins")
				puts "Feito!".green

				puts "\nConfigurando Gerenciamento de Riscos...".bold
				risk_types = [
					{code: 'RISCOPOS', title: 'Risco Positivo', description: 'Eventos que geram oportunidades com consequência positiva'},
					{code: 'RISCONEG', title: 'Risco Negativo', description: 'Eventos que geram ameaças com consequências negativas, levando a prejuízo nos projetos.'}					
				]
				RedmineGestaoMpRiskType.create(risk_types);
				
				risk_probabilities = [
					{multiplier: 1, code: 'MTOBXA', title: 'Muito Baixa'},
					{multiplier: 2, code: 'BAIXA', title: 'Baixa'},
					{multiplier: 3, code: 'MEDIA', title: 'Média'},
					{multiplier: 4, code: 'ALTA', title: 'Alta'},
					{multiplier: 5, code: 'MTOALT', title: 'Muito Alta'}
				]
				RedmineGestaoMpRiskProbability.create(risk_probabilities)				

				risk_impacts = [
					{multiplier: 1, code: 'MTOBXO', title: 'Muito Baixo'},
					{multiplier: 2, code: 'BAIXO', title: 'Baixo'},
					{multiplier: 3, code: 'MEDIO', title: 'Médio'},
					{multiplier: 4, code: 'ALTO', title: 'Alto'},
					{multiplier: 5, code: 'MTOALT', title: 'Muito Alto'}
				]
				RedmineGestaoMpRiskImpact.create(risk_impacts)				

				risco_negativo_id = RedmineGestaoMpRiskType.find_by_code('RISCONEG').id
				risco_positivo_id = RedmineGestaoMpRiskType.find_by_code('RISCOPOS').id
				risk_strategies = [
					{treatable: true, code: 'PRVNIR', title: 'Prevenir', description: 'Levar sua probabilidade ou impacto a zero, i.e., tornar impossível sua ocorrência ou eliminar seu efeito sobre o projeto. Possível com mudanças nas linhas de base do projeto. Exemplos: Cancelar o projeto; Eliminar item do escopo ou reduzir exigência de qualidade.', redmine_gestao_mp_risk_type_id: risco_negativo_id},
					{treatable: true, code: 'TRNSFRIR', title: 'Transferir', description: 'Mais eficaz ao lidar com a exposição a riscos financeiros. Quase sempre envolve o pagamento de um prêmio para quem está assumindo o risco. Exemplos: Uso de seguros, seguros-desempenho, garantias, fianças, etc.', redmine_gestao_mp_risk_type_id: risco_negativo_id},
					{treatable: true, code: 'MTGAR', title: 'Mitigar', description: 'Reduzir probabilidade  e/ou  impacto  de um evento de risco adverso para dentro de limites aceitáveis. Mais eficaz do que tentar reparar o dano depois de o risco ter ocorrido. Exemplos: Adotar processos mais simples; Fazer mais testes; Escolher fornecedor mais estável.', redmine_gestao_mp_risk_type_id: risco_negativo_id},
					{treatable: false, code: 'ACEITAR', title: 'Aceitar', description: 'Aceitar o risco significa que enquanto você o tiver identificado e registrado no seu plano de gerenciamento de riscos, você não vai tomar nenhuma ação. Simplesmente você aceita que ele possa acontecer e decidirá como lidar com ele caso ocorra.', redmine_gestao_mp_risk_type_id: risco_negativo_id},
					{treatable: true, code: 'EXPLRAR', title: 'Explorar', description: 'Quando se deseja garantir que a oportunidade seja concretizada. Procura eliminar a incerteza associada  a uma oportunidade,  garantindo  que  ela aconteça. Exemplos: Designar  os  recursos  mais talentosos  a  fim  de  reduzir  o  tempo  de  conclusão  ou para proporcionar um custo mais baixo do que foi originalmente planejado.', redmine_gestao_mp_risk_type_id: risco_positivo_id},
					{treatable: true, code: 'CMPTILHAR', title: 'Compartilhar', description: 'Envolve  a  alocação  integral  ou  parcial  da propriedade  da  oportunidade  a  um  terceiro  que  tenha  mais  capacidade  de  capturar  a oportunidade para benefício do projeto. Exemplos: Formação de parcerias de compartilhamento de riscos, empresas para fins especiais ou joint ventures, as quais podem ser estabelecidas com a finalidade expressa de aproveitar a oportunidade de modo que as partes se beneficiem das suas ações.', redmine_gestao_mp_risk_type_id: risco_positivo_id},
					{treatable: true, code: 'MELHORAR', title: 'Melhorar', description: 'Essa estratégia é usada para aumentar a probabilidade e/ou os impactos positivos de uma oportunidade. Identificar e maximizar os principais impulsionadores desses riscos de impacto positivo pode aumentar a probabilidade de ocorrência. Exemplos: Acréscimo de mais recursos a uma atividade para terminar mais cedo.', redmine_gestao_mp_risk_type_id: risco_positivo_id}
				]
				RedmineGestaoMpRiskStrategy.create(risk_strategies)				
				puts "Feito!".green
				
				puts "\nConfigurando Permissões para os perfis de Gerente, Desenvolvedor e Usuario Cliente...".bold
				Role.find(3).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_issues,
					:redmine_gestao_mp_view_config,
					:redmine_gestao_mp_create_config,
					:redmine_gestao_mp_edit_config,
					:redmine_gestao_mp_view_risks,
					:redmine_gestao_mp_create_risks,
					:redmine_gestao_mp_edit_risks,
					:redmine_gestao_mp_destroy_risks
				)

				Role.find(4).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_risks,
					:redmine_gestao_mp_view_issues
				)

				Role.find(7).add_permission!(
					:redmine_gestao_mp_view_home, 
					:redmine_gestao_mp_view_risks,
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
