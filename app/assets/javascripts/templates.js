$(function(){ 

	// Save template action
	$('#start').on("click", save_template_from_click);
	$('#start').on("keypress", save_template_from_keypress);

	// Update form according to content
	$('#publisher').on('change', update_publisher_view )
	$('#publisher_url_method').on('change', update_publisher_url_params_view )

	// Manage POST params list
	$('.publisher_url_post_params_add').on('click', add_url_post_params_from_click)
	$('.publisher_url_post_params_value').on('keypress', add_url_post_params_from_keypress)
	
	// EDIT stuff
	$.ajax({
		url: '/templates/new',
		type: 'get',
		dataType: 'script'
	});	
});

/**
*	Toggle form content according to Template publisher
**/
function update_publisher_view(event) {
	type = $(this).find(':selected').val();

	if( type === 'sql') {
		$('.publisher_sql').show();			
		$('.publisher_file').hide();
		$('.publisher_url').hide();
		$('.publisher_mail').hide();
		$('.publisher_dropbox').hide();
	} else if (type === 'url') {
		$('.publisher_sql').hide();			
		$('.publisher_file').hide();
		$('.publisher_url').show();
		$('.publisher_mail').hide();
		$('.publisher_dropbox').hide();
	} else if (type === 'file') {
		$('.publisher_sql').hide();			
		$('.publisher_file').show();
		$('.publisher_url').hide();
		$('.publisher_mail').hide();
		$('.publisher_dropbox').hide();
	} else if (type === 'mail') {
		$('.publisher_sql').hide();			
		$('.publisher_file').hide();
		$('.publisher_url').hide();
		$('.publisher_mail').show();
		$('.publisher_dropbox').hide();
	} else if (type === 'dropbox') {
		$('.publisher_sql').hide();			
		$('.publisher_file').hide();
		$('.publisher_url').hide();
		$('.publisher_mail').hide();
		$('.publisher_dropbox').show();
	}
}

/**
*	Toggle URL request params form according to request method
**/
function update_publisher_url_params_view(event) {
	type = $(this).find(':selected').val();
	if(type == 'post') {
		$('#publiser_url_post_params').show();
	} else {//if(type == 'get') {
		$('#publiser_url_post_params').hide();
	}
}

/**
*	Reload jQuery model to listen to new events for POST params "Remove" button
**/
function update_url_post_params_remove() {
	$('.publisher_url_params_remove').on('click', remove_url_post_params);
}


/**
*	Add POST param to list
**/
function add_url_post_params(id) {
	
	var destination = $('#publisher_url_post_params_include');
	var next_id = id +1;	
	var origin_key_text = $('#publisher_url_post_params_key_' + id);
	var origin_value_text = $('#publisher_url_post_params_value_' + id);
	var origin_button = $('#publisher_url_post_params_button_' + id); 
	
	// cleanup POST params form
	origin_key_text.parent().removeClass('error');
	origin_value_text.parent().removeClass('error');

	// validate POST params form
	if(!destination.is(':visible')) {
		destination.show();	
	}	
	if(origin_key_text.val() === '') {
		origin_key_text.parent().addClass('error');
	} else if (origin_value_text.val() === '') {
		origin_value_text.parent().addClass('error');
	} else {
		// process
		destination.append('<div class="row publisher_url_post_params_new_' + id + '"><div class="small-3 columns publisher_url_post_params_key_' + id + '"><input data-id="' + id  + '" type="text" placeholder="E.g.: id" disabled class="disabled publisher_url_post_params_key" value="' + origin_key_text.val() + '"></div><div class="small-7 columns publisher_url_post_params_value_' + id + '"><input id="publisher_url_post_params_value_' + id + '" type="text" placeholder="E.g.: id" disabled class="disabled " value="' + origin_value_text.val() + '"></div><div class="small-2 columns publisher_url_params_new_' + id + '"><a href="#" data-id="' + id +'" class="button prefix alert publisher_url_params_remove">Remove</a></div></div>');
		origin_key_text.removeAttr('id');
		origin_value_text.removeAttr('id');
		origin_button.removeAttr('id')
		origin_key_text.attr('id', 'publisher_url_post_params_key_' + next_id);
		origin_value_text.attr('id', 'publisher_url_post_params_value_' + next_id);
		origin_button.attr('id', 'publisher_url_post_params_button_' + next_id);
		origin_key_text.val('');
		origin_value_text.val('');
		origin_key_text.data('id', next_id);
		origin_value_text.data('id', next_id);
		origin_button.data('id', next_id);
		origin_key_text.focus();
		update_url_post_params_remove();
	}
}

/**
*	Add URL POST param  handler for button click
**/
function add_url_post_params_from_click(event) {
	event.preventDefault();
	add_url_post_params($(this).data('id'));

}

/**
*	Add URL POST param handler for "enter" keypress
**/
function add_url_post_params_from_keypress(event) {
	if(event.which == 13) {
		add_url_post_params($(this).data('id'));
	}	
}

/**
*	Removes existing POST param
**/
function remove_url_post_params(event) {
	event.preventDefault();
	$('.publisher_url_post_params_new_' + $(this).data('id')).remove();
}


/**
*	Click handler to save form content.
**/ 
function save_template_from_click(event) {
	event.preventDefault();
	save_template();
}

/**
*	Keypress handler to save form content.
**/ 
function save_template_from_keypress(event) {
	event.preventDefault();
	if(event.which == 13 || event.which == 32) {
		save_template();
	}
}

/**
*	Saves template (1. generate JSON string, 2. POST to server, 3. Redirect if success)
**/
function save_template() {
	
	var identifier = $('#template_identifier').val();
	var title = $('#template_title').val();
	var help = $('#template_help').val();
	var publisher = $('#publisher :selected').val();
	

	// generate payload content
	var payload = '{';

	if (publisher === 'sql') {
		payload += '"server":"' + $('#publisher_sql_server :selected').val() + '", ';
		payload += '"host":"' + $('#publisher_sql_host').val() + '",';
		payload += '"port":"' + $('#publisher_sql_port').val() + '",';
		payload += '"database":"' + $('#publisher_sql_database').val() + '", ';
		payload += '"username":"' + $('#publisher_sql_username').val() + '", ';
		payload += '"password":"' + $('#publisher_sql_password').val() + '", ';
		payload += '"query":"' + $('#publisher_sql_query').val() + '"';

	} else if (publisher === 'url') {
		payload += '"method":"' + $('#publisher_url_method :selected').val() + '", ';
		payload += '"uri":"' + $('#publisher_url_uri').val() + '"';

		$('#publisher_url_post_params_include').find('.publisher_url_post_params_key').each(function() {
			var key = $(this).val();
			var id = $(this).data('id');
			var value = $('#publisher_url_post_params_value_' + id).val();
			payload += ',"' + key + '":"' + value +'"'
		});

	} else if (publisher === 'file') {
		payload += '"method":"' + $('#publisher_file_method :selected').val() + '", ';
		payload += '"uri":"' + $('#publisher_file_uri').val() + '", ';
		payload += '"content":"' + $('#publisher_file_content').val() + '"';
	} else if (publisher === 'dropbox') {
		payload += '"method":"' + $('#publisher_dropbox_method :selected').val() + '", ';
		payload += '"uri":"' + $('#publisher_dropbox_uri').val() + '", ';
		payload += '"content":"' + $('#publisher_dropbox_content').val() + '"';
	}  else if (publisher === 'mail') {
		payload += '"to":"' + $('#publisher_mail_to').val() + '", ';
		payload += '"cc":"' + $('#publisher_mail_cc').val() + '", ';
		payload += '"bcc":"' + $('#publisher_mail_bcc').val() + '", ';
		payload += '"subject":"' + $('#publisher_mail_subject').val() + '", ';
		payload += '"message":"' + $('#publisher_mail_message').val() + '"';
	}  
	payload += '}';

	// generate final template object

	var template = '{"identifier":"' + identifier + '","title":"' + title + '","help":"' + help + '","publisher":"' + publisher + '","payload":' + payload + '}';
	
	$.ajax({
		url: "../templates/new",
		type: "POST",
		data: { message: template },
		dataType: 'json',
		success: handle_save
	})
}


/**
*	Handle save response
**/
function handle_save(data) {
	if(data.status === 200) {
		window.location = '../templates/' + data.id;
	} else {
		alert(data.message);
	}
}

/**
*	Validates the new Template form
**/
function validate_template() {
	var success = true;

	// check mandatory fields
	if($('#template_identifier').val() === '') {
		$('#template_identifier').parent().addClass('error');
		success = false;
	}

	if($('#template_title').val() === '') {
		$('#template_title').parent().addClass('error');
		success = false;
	}

	if($('#template_help').val() === '') {
		$('#template_help').parent().addClass('error');
		success = false;
	}


	// check publishers content
	var publisher = $('#publisher :selected').val();
	if (publisher === 'sql') {
	} else if (publisher === 'file') {
	/*	if(!$('#publisher_file_uri').val().startsWith('file://')) {
			$('#publisher_file_uri').parent().addClass('error');
			success = false;
		}*/
	} else if (publisher === 'url') {
		if(!$('#publisher_url_uri').val().startsWith('http://')) {
			$('#publisher_url_uri').parent().addClass('error');
			success = false;
		}

	}

	return success;
}