var create_editor = function() {
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/xcode");
	editor.getSession().setMode("ace/mode/javascript");
	var code = JSON.parse($('#code').val());
	editor.setValue(code.code);
	editor.getSession().getSelection().clearSelection();
	editor.getSession().on('change', function(e) {
		var code = {
			code: editor.getValue()
		};
		var code_json = JSON.stringify(code);
		$('#code').val(code_json);
	});
}

var create_gen_editors = function() {
	var mapeditor = ace.edit("mapeditor");
	mapeditor.setTheme("ace/theme/xcode");
	mapeditor.getSession().setMode("ace/mode/javascript");
	var reduceditor = ace.edit("reduceditor");
	reduceditor.setTheme("ace/theme/xcode");
	reduceditor.getSession().setMode("ace/mode/javascript");

	var code = JSON.parse($('#code').val());

	mapeditor.setValue(code.mapcode);
	mapeditor.getSession().getSelection().clearSelection();
	reduceditor.setValue(code.reducecode);
	reduceditor.getSession().getSelection().clearSelection();

	var codeOnChange = function(e) {
		var code = {
			mapcode: mapeditor.getValue(),
			reducecode: reduceditor.getValue()
		};
		var code_json = JSON.stringify(code);
		$('#code').val(code_json);
	}

	mapeditor.getSession().on('change', codeOnChange);
	reduceditor.getSession().on('change', codeOnChange);
}

var create_screen_editors = function() {
	var initEditor = function(id, mode) {
		var editor = ace.edit(id + "editor");
		editor.setTheme("ace/theme/xcode");
		editor.getSession().setMode("ace/mode/" + mode);

		var code = $('#' + id).val();
		editor.setValue(code);
		editor.getSession().getSelection().clearSelection();

		var codeOnChange = function(e) {
			var code = editor.getValue();
			$('#' + id).val(code);
		}
		editor.getSession().on('change', codeOnChange);
	}

	initEditor('attrs', 'json');
	initEditor('content', 'json');
}

var ts_to_string = function(ts) {
	var d = new Date(ts*1000);
	var pad = function(n){return n<10 ? '0'+n : n}
	return d.getFullYear()+'-'
		+ pad(d.getMonth()+1)+'-'
		+ pad(d.getDate())+' '
		+ pad(d.getHours())+':'
		+ pad(d.getMinutes())+':'
		+ pad(d.getSeconds())
}

var draw_state_table = function(table) {
	var tableHtml = '<table class="table"><tr><th>Key</th><th>Value</th><th>Last updated</th></tr>';
	for (var key in table) {
		var elem = table[key];
		var ts = ts_to_string(elem.LastUpdate);
		tableHtml += '<tr><td>' + key + '</td><td>' + elem.Value + '</td><td>' + ts + '</td></tr>';
	}
	tableHtml += '</table>';
	$('#dataplace').html(tableHtml);
}

var draw_vis_chart = function(cfg) {
	var params = {
		$object: $('.b-chart'),
		tAxes: [
			{
				rangeProvider: {
					name: 'i-current-time-range-provider',
					period: cfg.period,
					delay: 10000
				},
			}
		],
		xAxes: [
			{
				rangeProvider: { name: 'i-time-range-provider' },
				units: 'unixtime',
				processors: [
					{ name: 'i-average-processor', factor: 0.25 }
				]
			}
		],
		yAxes: [
			{ rangeProvider: { name: 'i-data-range-provider', min: -1, max: 1 } }
		],
		items: [
			{
				dataProvider: {
					name: 'i-hammy-data-provider',
					url: cfg.dataurl,
					host: cfg.hostname,
					key: cfg.itemkey
				},
			}
		],
		overlays: [
			{ name: 'b-grid-overlay' },
			{ name: 'b-render-overlay' },
			{ name: 'b-tooltip-overlay' }
		]
	};

	if (cfg.avgline) {
		params.items.push({
			dataProvider: {
				name: 'i-hammy-data-provider',
				url: cfg.dataurl,
				host: cfg.hostname,
				key: cfg.itemkey
			},
			filters: [
				{ name: 'i-average-filter', step: Math.round(cfg.period / 72) }
			],
			color: '#c00'
		});
	}

	Vis(params, 'b-chart');
}

var draw_screen = function(cfg, attrs, content) {
	var $container = $('body > .container');
	$.each(content, function() {
		var chart = this;
		var items = {};
		var params = {
			tAxes: [
				{
					rangeProvider: { name: 'i-current-time-range-provider', period: cfg.period, delay: 10000 }
				}
			],
			xAxes: [
				{
					rangeProvider: { name: 'i-time-range-provider' },
					units: 'unixtime',
					processors: [
						{ name: 'i-average-processor', factor: 0.25 }
					]
				}
			],
			items: [],
			yAxes: [
				{
					rangeProvider: { name: 'i-data-range-provider' }
				}
			],
			overlays: [
				{ name: 'b-grid-overlay' },
				{ name: 'b-render-overlay' },
				{ name: 'b-tooltip-overlay' }
			]
		};
		$.each(chart, function() {
			var item = this;
			(items[item.hostname] || (items[item.hostname] = [])).push(item.itemkey);
			params.items.push({
				dataProvider: {
					name: 'i-hammy-data-provider',
					url: cfg.dataurl,
					host: item.hostname,
					key: item.itemkey
				},
				color: item.color
			});
		});
		var hosts = [];
		$.each(items, function(hostname) {
			hosts.push(hostname + " :: " + this.join(", "));
		});
		var title = hosts.join("; ");

		var $title = $('<legend>', { text: title });
		$container.append($title);
		var $object = $('<div>');
		$container.append($object);

		params.$object = $object;
		Vis(params, 'b-chart');
	});
}
