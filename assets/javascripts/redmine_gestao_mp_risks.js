$(document).ready(function() {
	if (assetsAuthorized('redmine_gestao_mp_risks', 'new') || assetsAuthorized('redmine_gestao_mp_risks', 'create') ) {
		// var projectIdentification = location.pathname.split('/')[2];
		// var strategyUrl = `/projects/${projectIdentification}/gestao_mp/risk_strategies`;
		// var selectedRiskTypeId = $('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_type_id').val();
		// var selectedRiskStrategy = $('#redmine_gestao_mp_risk_strategy_id_p').data('value');

		// $('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_type_id').on('change', function() {
		// 	var riskTypeId = $(this).val() == '' ? 0 : $(this).val();
		// 	getGestaoMpRiskStrategies(strategyUrl, riskTypeId, selectedRiskStrategy);
		// })

		// if (selectedRiskTypeId != '') {
		// 	getGestaoMpRiskStrategies(strategyUrl, selectedRiskTypeId, selectedRiskStrategy);
		// }
	}
})

function getGestaoMpRiskStrategies(strategyUrl, riskTypeId, selectedRiskStrategy) {
	$.ajax({
	  url: strategyUrl,
	  data: {
	      redmine_gestao_mp_risk_type_id: riskTypeId
	  },
	  type: "GET",
	  dataType: "json",
	  success: function (result) {
	  		var options = [];
	      $.each(result, function(key, value) {
	      	options.push(`<option value='${value.id}'>${value.title}</option>`)
	      })
	      $('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_strategy_id').html(options);

   			if (selectedRiskStrategy != '') {
					$('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_strategy_id').val(selectedRiskStrategy);
				}
	  },
	  error: function (xhr, status) {
	      alert("Sorry, there was a problem!");
	  },
	  complete: function (xhr, status) {
	      //$('#showresults').slideDown('slow')
	  }
	});
}