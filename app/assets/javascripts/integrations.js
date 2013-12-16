$(function() {
	/***
	 ** New integration
	 ***/

	// Remote save new integration
	$('#new_integration').on('ajax:success', new_integration_save_meta);

	// Add agent to integration
	$('#new_save_agent_select').on('click', new_save_agent_select);
	$('#new_agent_select_list').on('keypress', function(e) {
		if (e.keyCode == 13) {
			new_save_agent_select(e);
		}
	});

	// Add template to integration
	$('#new_save_template_select').on('click', new_save_template_select);
	$('#new_template_select_list').on('keypress', function(e) {
		if (e.keyCode == 13) {
			new_template_agent_select(e);
		}
	});
	// Finalize integration save
	$('#new_integration_save_button').on('click', new_integration_save);

	/***
	 ** Edit integration
	 ***/

	// Remote save edited integration
	$('.edit_integration').on('ajax:success', save_edit_integration);

	// Remove agent from integration
	$('.remove_agent_integration').on('click', remove_agent_integration);

	// Remove template from integration
	$('.remove_template_integration').on('click', remove_template_integration);

	// Add agent to integration from edit
	$('#edit_save_agent_select').on('click', edit_save_agent_select);

	// Add template to integration from edit
	$('#edit_save_template_select').on('click', edit_save_template_select);

});

/**
 * On new integration, add agent to integration from select.
 **/
function new_save_agent_select(event) {
	event.preventDefault();
	var selected = $('#new_agent_select_list').find(':selected').val();
	if (selected === '0') {
		// show new agent form
		$('#new_agent_form').fadeIn(500);
	} else {
		// load existing agent data
		$.getJSON('../agents/get/' + selected + '.json', function(data) {
			$('#new_select_agent').html('<h5 id="agent" data-id="' + data.id + '"><a href="../agents/' + data.id + '" target="_blank">Agent <strong>' + data.title + '</strong></a></h5><div class="row"><div class="small-11 medium-12 large-11 columns right"><span class="label secondary radius icon-publisher">' + data.publisher + '</span> <span class="label secondary radius icon-schedule">' + data.schedule + '</span></div></div>');
		})
	}

	set_step(3);
	show_down($('#new_select_template'))
	$('#new_template_select_list').focus();
}

/**
 * On new integration, add template to integration from select.
 **/
function new_save_template_select(event) {
	event.preventDefault();
	var selected = $('#new_template_select_list').find(':selected').val();
	if (selected === '0') {
		// show new agent form
		$('#new_template_form').fadeIn(500);
	} else {
		// load existing agent data
		$.getJSON('../templates/get/' + selected + '.json', function(data) {
			$('#new_select_template').html('<h5 id="template" data-id="' + data.id + '"><a href="../templates/' + data.id + '" target="_blank">Template <strong>' + data.title + '</strong></a></h5><div class="row"><div class="small-11 medium-12 large-11 columns right"><span class="label secondary radius icon-publisher">' + data.publisher + '</span></div></div>');
		})
	}

	set_step(3);
	show_down($('#new_integration_save'));
}



/**
 * Save new integration complete.
 **/
function new_integration_save(event) {
	event.preventDefault();
	var data = {};
	data.agent = $('#agent').data('id');
	data.template = $('#template').data('id');
	data.id = $('#integration').data('id');
	$.post('../integrations/' + data.id + '/save.json', data, function(response) {
		window.location = '../integrations/' + data.id;
	})
}


/**
 *	Save new integration metadata (creates @integration on database).
 **/
function new_integration_save_meta(e, data, status, xhr) {
	if (status === 'success') {
		integration = JSON.parse(xhr.responseText);
		// replace form content with integration details.
		$("#new_integration").html('<h4 id="integration" data-id="' + integration.id + '">Integration <strong>' + integration.title + '</strong></h4>');
		// update step counter
		set_step(2);

	}
	// show agent select 	
	show_down($('#new_select_agent'));
	$('#new_agent_select_list').focus();
}

/**
 * Process server response from editing integration properties.
 **/
function save_edit_integration(e, data, status, xhr) {
	if (status === 'success') {
		$('.integration_save').val('Saved');
		$('.edit_integration :input').on('change', function() {
			$('.integration_save').val('Save');
		})
	}
}

/**
 *	Detach template from integration
 **/
function remove_template_integration(event) {
	event.preventDefault();
	var data = {};
	data.id = $('#integration').data('id');
	data.remove = true;
	data.template = $(this).data('id');
	$.post('../' + data.id + '/save.json', data, function(response) {
		window.location.reload();
	})
}
/**
 *	Detach agent from integration.
 **/
function remove_agent_integration(event) {
	event.preventDefault();
	var data = {};
	data.id = $('#integration').data('id');
	data.remove = true;
	data.agent = $(this).data('id');
	$.post('../' + data.id + '/save.json', data, function(response) {
		window.location.reload();
	})
}


/**
 * On edit, add template to integration from select.
 **/
function edit_save_template_select(event) {
	event.preventDefault();
	var selected = $('#edit_template_select_list').find(':selected').val();
	if (selected === '0') {
		// show new agent form
	} else {
		// load existing agent data
		var data = {};
		data.id = $('#integration').data('id');
		data.template = selected;
		$.post('../' + data.id + '/save.json', data, function(response) {
			window.location.reload();
		})
	}
}

/**
 * On edit, add agent to integration from select.
 **/
function edit_save_agent_select(event) {
	event.preventDefault();
	var selected = $('#edit_agent_select_list').find(':selected').val();
	if (selected === '0') {
		// show new agent form
	} else {
		// load existing agent data
		var data = {};
		data.id = $('#integration').data('id');
		data.agent = selected;
		$.post('../' + data.id + '/save.json', data, function(response) {
			window.location.reload();
		})
	}
}
/**
 *	Show stuff with fade in and slide down
 **/
function show_down(element) {
	element.css('opacity', 0).slideDown('slow').animate({
		opacity: 1
	}, {
		queue: false,
		duration: 'slow'
	}).removeClass('hidden');
}

/**
 *	Update step counter on new integration wizard.
 **/
function set_step(step) {
	$('#step').hide().html(' Step <strong>' + step + '</strong>').fadeIn(500);
}