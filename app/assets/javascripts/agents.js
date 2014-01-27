$(function() {
	// Remote save new agent
	$('#new_agent').on('ajax:success', new_agent_save);

	// Remote save edited agent
	$('.edit_agent').on('ajax:success', edit_agent_save);
});

/**
 *	Redirect on agent save.
 **/
function new_agent_save(e, data, status, xhr) {
	if (status === 'success') {
		agent = JSON.parse(xhr.responseText);
		window.location = '../agents/' + agent.id;
	}
}

/**
 *	Redirect on agent edit.
 **/
function edit_agent_save(e, data, status, xhr) {
	if (status === 'success') {
		$('#save_agent').val('Saved');
		$('.edit_agent :input').on('change', function() {
			$('#save_agent').val('Save');
		})
	}

}