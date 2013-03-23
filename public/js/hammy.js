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