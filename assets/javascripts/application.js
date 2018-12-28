var assetsAuthorized = function(controller, action) {
	return $('body').hasClass('controller-' + controller) && $('body').hasClass('action-' + action)
}

// $.when(
//     $.getScript( "/plugin_assets/redmine_gestao_mp/javascripts/jquery-ui/jquery-ui.min.js" ),
//     $.getScript( "/plugin_assets/redmine_gestao_mp/javascripts/jstree/jstree.js", function() {
//     	$.getScript( "/plugin_assets/redmine_gestao_mp/javascripts/jstree/plugins/jstreetable.js" )
//     }),    
//     $.Deferred(function( deferred ){
//       $( deferred.resolve );
//     })
// ).done(function(){
// 	$.getScript( "/plugin_assets/redmine_gestao_mp/javascripts/redmine_gestao_mp_issues.js" );
//     console.log('Assets Gestao MP carregados.')

// });

$.extend({
  getUrlVars: function(){
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
      hash = hashes[i].split('=');
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  }
});