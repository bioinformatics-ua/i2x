$(function(){ 


	$('#start').on("click", save_template_from_click);
	$('#start').on("keypress", save_template_from_keypress);

	$('#publisher').on('change', update_publisher_view )

	$('.template_variables_add').on('click', add_template_variable_from_click)

	$('.template_variable_text').on('keypress', add_template_variable_from_keypress)
	
});

/**
*	Toggle shown form according to Template publisher
**/
function update_publisher_view(event) {
	type = $(this).find(':selected').val();

	if( type === 'sql') {
		$('.publisher_sql').show();			
		$('.publisher_file').hide();
		$('.publisher_url').hide();

	} else if (type === 'url') {
		$('.publisher_sql').hide();			
		$('.publisher_file').hide();
		$('.publisher_url').show();

	} else if (type === 'file') {
		$('.publisher_sql').hide();			
		$('.publisher_file').show();
		$('.publisher_url').hide();

	}
}

/**
*	Reload jQuery model to listen to new events for variable "Remove" button
**/
function update_template_variables_remove() {
	$('.template_variables_remove').on('click', remove_template_variable);
}

/**
*	Add Template variable
**/
function add_template_variable(id) {
	
	var destination = $('#template_variables_include');
	var next_id = id +1;	
	var origin_text = $('#template_variables_text_' + id);
	var origin_button = $('#template_variables_button_' + id); 
	
	if(!destination.is(':visible')) {
		destination.show();	
	}	
	destination.append('<div class="small-10 columns template_variables_new_' + id + '"><input type="text" placeholder="E.g.: id" disabled class="disabled template_variable_text" value="' + origin_text.val() + '"></div><div class="small-2 columns template_variables_new_' + id + '"><a href="#" data-id="' + id +'" class="button prefix alert template_variables_remove">Remove</a></div>');
	origin_text.removeAttr('id')
	origin_button.removeAttr('id')
	origin_text.attr('id', 'template_variables_text_' + next_id);
	origin_button.attr('id', 'template_variables_button_' + next_id);
	origin_text.val('');
	origin_text.data('id', next_id);
	origin_button.data('id', next_id);
	update_template_variables_remove();
	$('.template_variables_base').parent().removeClass('error');
}

/**
*	Add Template variable handler for button click
**/
function add_template_variable_from_click(event) {
	event.preventDefault();
	add_template_variable($(this).data('id'));

}

/**
*	Add Template variable handler for "enter" keypress
**/
function add_template_variable_from_keypress(event) {
	if(event.which == 13) {
		add_template_variable($(this).data('id'));
	}	
}

/**
*	Removes existing Template variable
**/
function remove_template_variable(event) {
	event.preventDefault();
	$('.template_variables_new_' + $(this).data('id')).remove();
}

function save_template_from_click(event) {
	event.preventDefault();
	save_template();
}

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
	
	// generate variables content
	var variables = '[';

	if (!validate_template()) {
		//alert('Something\'s not right...');
	} else {
		$('#template_variables_include').find('.template_variable_text').each(function() {		
			var value = $(this).val();

			if (value != '') {
				variables += '"' + value + '", ';
			}		
		})
		variables = variables.substring(0, variables.length - 2);
		variables += ']';

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

	} else if (publisher === 'file') {
		payload += '"method":"' + $('#publisher_file_method :selected').val() + '", ';
		payload += '"uri":"' + $('#publisher_file_uri').val() + '", ';
		payload += '"content":"' + $('#publisher_file_content').val() + '"';
	}  
	payload += '}';

	// generate final template object

	var template = '{"identifier":"' + identifier + '","title":"' + title + '","help":"' + help + '","publisher":"' + publisher + '","variables":' + variables + ',"payload":' + payload + '}';
	
	$.ajax({
		url: "../templates/new",
		type: "POST",
		data: { message: template },
		dataType: 'json',
		success: handle_save
	})
}
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

	// check if there are variables
	if ($('#template_variables_include').find('.template_variable_text').length == 0) {
		$('.template_variables_base').parent().addClass('error');
		success = false;
	}

	// check publishers content
	var publisher = $('#publisher :selected').val();
	if (publisher === 'sql') {
	} else if (publisher === 'file') {
		if(!$('#publisher_file_uri').val().startsWith('file://')) {
			$('#publisher_file_uri').parent().addClass('error');
			success = false;
		}
	} else if (publisher === 'url') {
		if(!$('#publisher_url_uri').val().startsWith('http://')) {
			$('#publisher_url_uri').parent().addClass('error');
			success = false;
		}
	}

	return success;
}