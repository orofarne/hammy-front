var saveCode = function(editor, key) {
	var code = editor.getValue();
	$.ajax({
		url: "/save_trigger",
		type: "POST",
		data: {
			key: key,
			code: code
		},
		success: function( data ) {
			$("#res").html("<strong>" + data + "</strong>");
			setTimeout(function() {
				$("#res").html("");
			}, 10000);
		},
		error: function( jqXHR, textStatus, errorThrown ) {
			$("#res").html("<strong>Error! :-(</strong>");
			setTimeout(function() {
				$("#res").html("");
			}, 10000);
		}
	});
}

var loadCode = function(editor, key) {
	editor.setReadOnly(true);
	$("#res").html("<strong>Loading...</strong>");
	$.ajax({
		url: "/get_trigger",
		type: "GET",
		data: {
			key: key
		},
		success: function( data ) {
			editor.setValue(data);
			editor.setReadOnly(false);
			editor.getSession().getSelection().clearSelection();
			$("#res").html("<strong>Code loaded!</strong>");
			setTimeout(function() {
				$("#res").html("");
			}, 10000);
		},
		error: function( jqXHR, textStatus, errorThrown ) {
			$("#res").html("<strong>Error! :-(</strong>");
			setTimeout(function() {
				$("#res").html("");
			}, 10000);
		}
	});
}
