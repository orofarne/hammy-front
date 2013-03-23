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