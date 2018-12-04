$(document).ready(function() {
	if (assetsAuthorized('redmine_gestao_mp_issues', 'index')) {

		$("#redmine-gestao-mp-issues-table").fancytree({
			extensions: ["table", "persist"],
			table: {
				indentation: 20,      // indent 20px per node level
				nodeColumnIdx: 1     // render the node title into the 2nd column
			},
			source: $('#redmine-gestao-mp-issues-table').data('issues'),
			renderColumns: function(event, data) {
				var node = data.node, $tdList = $(node.tr).find(">td");
				
				$tdList.eq(0).html("<span class='redmine-gestao-mp-light " + node.data.light + "-light'></span>");
				$tdList.eq(2).text(node.data.start_date);
				$tdList.eq(3).text(node.data.due_date);
				$tdList.eq(4).text(node.data.assigned_to);
			},
      persist: {
      	cookiePrefix: "fancytree-redmine-gestao-mp-" + $('#redmine-gestao-mp-issues-table').data('project-id') + "-project",
        expandLazy: true,
        // fireActivate: false,    // false: suppress `activate` event after active node was restored
        // overrideSource: false,  // true: cookie takes precedence over `source` data attributes.
        store: "auto" // 'cookie', 'local': use localStore, 'session': sessionStore
        // Sample for a custom store:
        // store: {
        //   get: function(key){ this.info("get(" + key + ")"); return window.sessionStorage.getItem(key); },
        //   set: function(key, value){ this.info("set(" + key + ", " + value + ")"); window.sessionStorage.setItem(key, value); },
        //   remove: function(key){ this.info("remove(" + key + ")"); window.sessionStorage.removeItem(key); }
        // }
      },
			renderNode: function(event, data) {
				var node = data.node;
        var $span = $(node.span);
        var icon = node.data.class_type == 'Project' ? '/images/projects.png' : '/images/ticket.png'

        $span.find("> span.fancytree-icon").css({
          backgroundImage: "url(" + icon + ")",
          backgroundPosition: "0 0"
        });

			}
		});



	}
})