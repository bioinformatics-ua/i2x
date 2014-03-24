// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
// require turbolinks
//= require_tree .

if (typeof String.prototype.startsWith != 'function') {
  String.prototype.startsWith = function(str) {
    return this.slice(0, str.length) == str;
  };
}

if (typeof String.prototype.endsWith != 'function') {
  String.prototype.endsWith = function(str) {
    return this.slice(-str.length) == str;
  };
}
if (typeof String.prototype.addSlashes != 'function') {
  String.prototype.addSlashes = function() {
    return this;
  }
}

$(function() {
  $(document).foundation();

  // fix sidebar height
  if ($('#sidebar').height() < $(window).height()) {
    $('#sidebar').height($(window).height());
  }


  // API KEY MANAGEMENT
  update_user_remove_key_selectors();

  //temp for user adding keys
  $('#user_add_api_key').on('click', update_user_generate_key);

});

/**
 *	Add User API keys (no reload!).
 *
 **/
function update_user_generate_key(event) {
  event.preventDefault();

  $.post('../fluxcapacitor/generate_key.json', function(response) {
    if (response.status === 100) {
      $('#api_keys').append('<li id="user_api_key_' + response.access_token + '"><a href="../fluxcapacitor/generate_client.json?access_token=' + response.access_token + '" class="has-tip icon-download" title="Download sample client" target="_blank" data-tooltip></a> ' + response.access_token + ' <a href="#" title="Remove API key" data-tooltip class="has-tip remove icon-trash user_remove_api_key" data-id="' + response.access_token + '"></a></li>')
      update_user_remove_key_selectors();
    } else {
      alert('[i2x] unable to generate new API key.')
    }
  });

}


/**
 *	Remove User API keys (no reload!).
 *
 **/
function update_user_remove_key_selectors() {
  $('.user_remove_api_key').on('click', function(event) {
    event.preventDefault();
    var data = {};
    data.access_token = $(this).data('id');
    $.post('../fluxcapacitor/remove_key.json', data, function(response) {
      if (response.status === 100) {
        $('#user_api_key_' + response.access_token).remove();
      }
    });
  });
}

/**
 *	Show stuff with fade in and slide down
 **/
function show_down(element) {
    element.removeClass('hidden').addClass('animated fadeIn');
}
