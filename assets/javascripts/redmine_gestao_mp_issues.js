$(document).ready(function() {
	if (assetsAuthorized('redmine_gestao_mp_issues', 'index')) {

		$("#redmine-gestao-mp-issues-table").fancytree({
			extensions: ["table"],
			table: {
				indentation: 20,      // indent 20px per node level
				nodeColumnIdx: 0     // render the node title into the 2nd column
			},
			source: $('#redmine-gestao-mp-issues-table').data('issues'),
			renderColumns: function(event, data) {
				var node = data.node, $tdList = $(node.tr).find(">td");
				
				$tdList.eq(1).text(node.data.start_date);
				$tdList.eq(2).text(node.data.due_date);
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