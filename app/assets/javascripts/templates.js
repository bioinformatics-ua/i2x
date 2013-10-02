$(function(){ 
	$('#start').on("click", function(event){
		event.preventDefault();
		var template = {//'{"identifier":"' + $('#template_identifier').val() + '","title":"' + $('#template_title').val()+ '","help":"' + $('#template_help').val()+ '","payload":' + $('#template_payload').val() + '}';
			identifier: $('#template_identifier').val(),
			title: $('#template_title').val(),
			help: $('#template_help').val(),
			publisher: $('#template_publisher').val(),
			variables: $('#template_variables').val(),
			payload: $('#template_payload').val()
		};

		$.ajax({
			url: "http://localhost:3000/templates/start",
			type: "POST",
			data: { message: JSON.stringify(template) },
			dataType: "json",
			success: function() {alert('sent')}
		});

	});
});