var create_editor = function() {
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/xcode");
	editor.getSession().setMode("ace/mode/ruby");
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
	mapeditor.getSession().setMode("ace/mode/ruby");
	var reduceditor = ace.edit("reduceditor");
	reduceditor.setTheme("ace/theme/xcode");
	reduceditor.getSession().setMode("ace/mode/ruby");

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

var draw_state_table = function(data) {
	var table = JSON.parse(data);
	var tableHtml = '<table class="table"><tr><th>Key</th><th>Value</th><th>Last updated</th></tr>';
	for (var key in table) {
		var elem = table[key];
		var ts = ts_to_string(elem.LastUpdate);
		tableHtml += '<tr><td>' + key + '</td><td>' + elem.Value + '</td><td>' + ts + '</td></tr>';
	}
	tableHtml += '</table>';
	$('#dataplace').html(tableHtml);
}