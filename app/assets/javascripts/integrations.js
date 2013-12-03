$(function(){ 
	$('#new_integration').on('ajax:success', function(e, data, status, xhr){
		if (status === 'success') {
			integration = JSON.parse(xhr.responseText)
			$("#new_integration").html('<h4>Integration <strong>' + integration.title + '</strong></h4>');
			set_step(2)
			
		}	
		$('#select_agent').fadeIn(1000);
	});

	$('#save_agent_select').on('click', function(event) {
		event.preventDefault();
		var selected = $('#agent_select_list').find(':selected').val();
		if(selected === '0') {
			// show new agent form
			$('#new_agent_form').fadeIn(500);
		} else {
			// load existing agent data
			$.getJSON('../agents/get/' + selected + '.json', function(data) {
				$('#select_agent').html('<h5>Agent <strong>' + data.title + '</strong></h5>');	
			})
		}

		set_step(3);
		$('#select_template').fadeIn(1000);
	})

	$('#save_template_select').on('click', function(event) {
		event.preventDefault();
		var selected = $('#template_select_list').find(':selected').val();
		if(selected === '0') {
			// show new agent form
			$('#new_agent_form').fadeIn(500);
		} else {
			// load existing agent data
			$.getJSON('../templates/get/' + selected + '.json', function(data) {
				$('#select_template').html('<h5>Template <strong>' + data.title + '</strong></h5>');	
			})
		}

		set_step(3);
		$('#select_template').fadeIn(1000);
	})
});

function set_step(step) {
	$('#step').hide().html(' Step <strong>' + step +'</strong>').fadeIn(500);
}