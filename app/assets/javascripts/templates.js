$(function() {
	// Remote save new template
	$('#new_template').on('ajax:success', new_template_save);

	// Update template action
	$('.edit_template').on('ajax:success', edit_template_save);
});



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
	var selectors = JSON.parse($('#url_post_params_hidden').val());

	var destination = $('#publiser_url_post_params');
	var next_id = id + 1;
	var origin_key_text = $('#publisher_url_post_params_key_' + id);
	var origin_value_text = $('#publisher_url_post_params_value_' + id);
	var origin_button = $('#publisher_url_post_params_button_' + id);

	// cleanup POST params form
	origin_key_text.parent().removeClass('error');
	origin_value_text.parent().removeClass('error');

	// update hidden content
	var selector = '{"' + origin_key_text.val() + '":"' + origin_value_text.val() + '"}'
	selectors.push(JSON.parse(selector))
	$('#url_post_params_hidden').val(JSON.stringify(selectors));

	// validate POST params form
	if (!destination.is(':visible')) {
		destination.show();
	}
	if (origin_key_text.val() === '') {
		origin_key_text.parent().addClass('error');
	} else if (origin_value_text.val() === '') {
		origin_value_text.parent().addClass('error');
	} else {
		// process
		destination.append('<div class="row publisher_url_post_params_new_' + id + '"><div class="small-3 columns"><label class="right inline">Parameter ' + id + '</label></div><div class="small-4 columns publisher_url_post_params_key_' + id + '"><input id="publisher_url_post_params_key_' + id + '" data-id="' + id + '" type="text" placeholder="E.g.: id" disabled class="disabled publisher_url_post_params_key" value="' + origin_key_text.val() + '"/></div><div class="small-4 columns publisher_url_post_params_value_' + id + '"><input id="publisher_url_post_params_value_' + id + '" type="text" placeholder="E.g.: id" disabled class="disabled " value="' + origin_value_text.val() + '" /></div><div class="small-1 columns publisher_url_params_new_' + id + '"><a href="#" data-id="' + id + '" class="remove publisher_url_params_remove">Remove</a></div></div>');
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
		$('#save_template').val('Save');
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
	if (event.which == 13) {
		add_url_post_params($(this).data('id'));
	}
}

/**
 *	Removes existing POST param
 **/
function remove_url_post_params(event) {
	event.preventDefault();
	var id = $(this).data('id');
	var selectors = JSON.parse($('#url_post_params_hidden').val());
	var key = $('#publisher_url_post_params_key_' + id).val();
	var value = $('#publisher_url_post_params_value_' + id).val();
	selectors = remove_obj_from_array(selectors, JSON.parse('{"' + key + '":"' + value + '"}'));
	$('#url_post_params_hidden').val(JSON.stringify(selectors));
	$('.publisher_url_post_params_new_' + id).remove();
	$('#save_template').val('Save');
	//alert($('#url_post_params_hidden').val());
}

/**
 *	Redirect on template save.
 **/
function new_template_save(e, data, status, xhr) {
	if (status === 'success') {
		template = JSON.parse(xhr.responseText);
		window.location = '../templates/' + template.id;
	}
}

/**
 *	Redirect on template edit.
 **/
function edit_template_save(e, data, status, xhr) {
	if (status === 'success') {
		$('#save_template').val('Saved');
		$('.edit_template :input').on('change', function() {
			$('#save_template').val('Save');
		})
	}
}

/** Remove given object from object array **/
function remove_obj_from_array(list, val) {
	for (var i = 0; i < list.length; i++) {
		var json_obj = list[i];
		for (var key in json_obj) {
			for (var k in val) {
				if (json_obj[key] === val[k]) {
					list.splice(i, 1);
					i--;
				}
			}
		}
	}
	return list;
}