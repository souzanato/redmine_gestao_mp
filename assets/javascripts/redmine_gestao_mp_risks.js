var gauges = [];

$(document).ready(function() {
	if (assetsAuthorized('redmine_gestao_mp_risks', 'index')) {
		new showHideText('.redmine-gestao-mp-risk-desc-trim', {
	    charQty     : 100,
	    ellipseText : "...",
	    moreText: 'Ver mais',
	    lessText: 'Ver menos'
		});

		createGauges();
		updateGauges();

	}
	
	if (assetsAuthorized('redmine_gestao_mp_risks', 'new') || assetsAuthorized('redmine_gestao_mp_risks', 'create') || 
				assetsAuthorized('redmine_gestao_mp_risks', 'edit') || assetsAuthorized('redmine_gestao_mp_risks', 'update') ) {
		var projectIdentification = location.pathname.split('/')[2];
		var strategyUrl = `/projects/${projectIdentification}/gestao_mp/risk_strategies`;
		var selectedRiskTypeId = $('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_type_id').val();
		var selectedRiskStrategy = $('#redmine_gestao_mp_risk_strategy_id_p').data('value');

		$('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_type_id').on('change', function() {
			var riskTypeId = $(this).val() == '' ? 0 : $(this).val();
			getGestaoMpRiskStrategies(strategyUrl, riskTypeId, selectedRiskStrategy);
		})

		if (selectedRiskTypeId != '') {
			getGestaoMpRiskStrategies(strategyUrl, selectedRiskTypeId, selectedRiskStrategy);
		}
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

				if ($('body').hasClass('action-edit')) {
					$('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_strategy_id').val($('#redmine_gestao_mp_risk_redmine_gestao_mp_risk_strategy_id').data('selected'));
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

function createGauge(name, label, min, max)
{
	var config = 
	{
		size: 120,
		label: label,
		min: undefined != min ? min : 0,
		max: undefined != max ? max : 100,
		minorTicks: 5
	}
	
	var range = config.max - config.min;
	// config.yellowZones = [{ from: config.min + range*0.75, to: config.min + range*0.9 }];
	// config.redZones = [{ from: config.min + range*0.9, to: config.max }];
	config.yellowZones = [{ from: $('#redmine-gestao-mp-risk-ranges').data('medium-start'), to: $('#redmine-gestao-mp-risk-ranges').data('medium-end') }];
	config.redZones = [{ from: $('#redmine-gestao-mp-risk-ranges').data('high-start'), to: $('#redmine-gestao-mp-risk-ranges').data('high-end') }];
	
	gauges[name] = new Gauge(name + "GaugeContainer", config);
	gauges[name].render();
}

function createGauges()
{
	createGauge("risconeg", "Negativo");
	createGauge("riscopos", "Positivo");
	// createGauge("cpu", "CPU");
	// createGauge("network", "Network");
	//createGauge("test", "Test", -50, 50 );
}

function updateGauges()
{	
	for (var key in gauges)
	{

		// var value = getRandomValue(gauges[key])
		gauges[key].redraw($(`#${key}GaugeContainer`).data('risk-meter'));
	}
}

function getRandomValue(gauge)
{
	var overflow = 0; //10;
	return gauge.config.min - overflow + (gauge.config.max - gauge.config.min + overflow*2) *  Math.random();
}
			