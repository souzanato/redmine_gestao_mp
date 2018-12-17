$(document).ready(function() {
	if (assetsAuthorized('redmine_gestao_mp_config', 'index')) {

		new showHideText('.redmine-gestao-mp-config-desc-trim', {
	    charQty     : 100,
	    ellipseText : "...",
	    moreText: 'Ver mais',
	    lessText: 'Ver menos'
		});


	}
})