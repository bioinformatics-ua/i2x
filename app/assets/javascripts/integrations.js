$(function(){ 
	$('#new_integration').on('ajax:success', function(e, data, status, xhr){
		if (status === 'success') {
			integration = JSON.parse(xhr.responseText)
			$("#new_integration").html('<h4 id="integration" data-id="' + integration.id + '">Integration <strong>' + integration.title + '</strong></h4>');
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
				$('#select_agent').html('<h5 id="agent" data-id="' + data.id + '"><a href="../agents/' + data.id + '" target="_blank">Agent <strong>' + data.title + '</strong></a></h5><div class="row"><div class="small-11 medium-12 large-11 columns right"><span class="label secondary radius"><i class="icon-level-up"></i>' + data.publisher + '</span> <span class="label secondary radius"><i class="icon-back-in-time"></i>' + data.schedule +'</span></div></div>');	
			})
		}

		set_step(3);
		$('#select_template').fadeIn(500);
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
				$('#select_template').html('<h5 id="template" data-id="' + data.id + '"><a href="../templates/' + data.id + '" target="_blank">Template <strong>' + data.title + '</strong></a></h5><div class="row"><div class="small-11 medium-12 large-11 columns right"><span class="label secondary radius"><i class="icon-level-up"></i>' + data.publisher + '</span></div></div>');
			})
		}

		set_step(3);
		$('#integration_save').fadeIn(500);

	})

	$('#integration_save_button').on('click', function(event){
		event.preventDefault;
		var data = {};
		data.agent = $('#agent').data('id');
		data.template = $('#template').data('id');
		data.id = $('#integration').data('id');
		$.post('../integrations/save/' + data.id + '.json', data, function(response) {
			Turbolinks.visit('../integrations/' + data.id);
			})
	})
});

function set_step(step) {
	$('#step').hide().html(' Step <strong>' + step +'</strong>').fadeIn(500);
}