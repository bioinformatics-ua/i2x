$(function(){ 
	$('#new_integration').on('ajax:success', function(e, data, status, xhr){
		if (status === 'success') {
			integration = JSON.parse(xhr.responseText)
			$("#new_integration").html('<h4 id="integration" data-id="' + integration.id + '">Integration <strong>' + integration.title + '</strong></h4>');
			set_step(2)
			
		}	
		$('#select_agent').fadeIn(1000);
	});

	$('.edit_integration').on('ajax:success', function(e, data, status, xhr){
		
		if (status === 'success') {
			$('.integration_save').val('Saved');
			$('.edit_integration :input').on('change', function() {
				$('.integration_save').val('Save');
			})
		}	
		
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
		event.preventDefault();
		var data = {};
		data.agent = $('#agent').data('id');
		data.template = $('#template').data('id');
		data.id = $('#integration').data('id');
		$.post('../integrations/' + data.id + '/save.json', data, function(response) {
			Turbolinks.visit('../integrations/' + data.id);
		})
	})

		$('#edit_save_new_agent_button').on('click', function(event){
		event.preventDefault();
		var data = {};
		data.agent = $('#agent_select_list').find(':selected').val();
		data.id = $('#integration').data('id');
		$.post('../' + data.id + '/save.json', data, function(response) {
			Turbolinks.visit('../' + data.id + '/edit');
		})
	})

	$('#add_new_agent_button').on('click', function(event){
		event.preventDefault();
		$('#add_new_agent_row').fadeOut(300);
		$('#select_agent').fadeIn(300);
	})

		$('#edit_add_new_agent_button').on('click', function(event){
		event.preventDefault();
		$('#edit_add_button_row').slideUp(300, function(){$('#select_agent').slideDown(500);});
		
	})

		$('#edit_save_agent_select').on('click', function(event) {
		event.preventDefault();
		var selected = $('#agent_select_list').find(':selected').val();
		if(selected === '0') {
			// show new agent form
			//$('#new_agent_form').fadeIn(500);
		} else {
			// load existing agent data
			$.getJSON('../agents/get/' + selected + '.json', function(data) {
				$('#select_agent').html('<h5 id="agent" data-id="' + data.id + '"><a href="../agents/' + data.id + '" target="_blank">Agent <strong>' + data.title + '</strong></a></h5><div class="row"><div class="small-11 medium-12 large-11 columns right"><span class="label secondary radius"><i class="icon-level-up"></i>' + data.publisher + '</span> <span class="label secondary radius"><i class="icon-back-in-time"></i>' + data.schedule +'</span></div></div>');	
			})
		}

		
	})
});

function set_step(step) {
	$('#step').hide().html(' Step <strong>' + step +'</strong>').fadeIn(500);
}