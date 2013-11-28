$(function(){ 
	$('#new_integration').on('ajax:success', function(e, data, status, xhr){
		if (status === 'success') {
			$("#new_integration").html('');
			$('#step').hide().html(' Step <strong>2</strong>').fadeIn(500);
		}	$('#select_agent').fadeIn(1000);
	});

	$('#agent_select').on('change', function(event) {
		var selected = $(this).find(':selected').val();

		if(selected === '0') {
			// show new agent form
		} else {
			// load existing agent data
			$.getJSON('../agents/get/' + selected + 'json', function(data) {
				alert(data.title);
			})
		}
	});
});