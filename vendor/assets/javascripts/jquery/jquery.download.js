/*
 * --------------------------------------------------------------------
 * jQuery-Plugin - $.download - allows for simple get/post requests for files
 * by Scott Jehl, scott@filamentgroup.com
 * http://www.filamentgroup.com
 * reference article: http://www.filamentgroup.com/lab/jquery_plugin_for_requesting_ajax_like_file_downloads/
 * Copyright (c) 2008 Filament Group, Inc
 * Dual licensed under the MIT (filamentgroup.com/examples/mit-license.txt) and GPL (filamentgroup.com/examples/gpl-license.txt) licenses.
 * --------------------------------------------------------------------
 */
 
jQuery.download = function(url, data, method) {
  //url and data options required
  if ( url && data ) {
    // data can be string of parameters or array/object
    data = typeof data == 'string' ? data : jQuery.param(data);
    
    // split params into form inputs
    var inputs = '';
    jQuery.each(data.split('&'), function(){
      var pair = this.split('=');
      inputs += '<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
    });

    // add CSRF protection
    var csrf_token = jQuery('meta[name=csrf-token]').attr('content');
    var csrf_param = jQuery('meta[name=csrf-param]').attr('content');
    if ( (csrf_param !== undefined) && (csrf_token !== undefined) )
      inputs += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
  
    // send request
    jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">' + inputs + '</form>')
      .appendTo('body').submit().remove();
  };
};
