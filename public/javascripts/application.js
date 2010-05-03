// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function changeTooltip(element_id, new_message){
	eval('var tt_var = var_tt_' + element_id)			
	tt_var.destroy();
	tt_var = new YAHOO.widget.Tooltip("tt_" + element_id, { context: element_id, text: new_message });
	eval('var_tt_' + element_id + ' = tt_var')
}

function addWatchClickListener(elementId, videoId, newWatchedValue) {
    YAHOO.util.Event.removeListener(elementId, 'click');
    YAHOO.util.Event.addListener(elementId, "click", function(){markVideoWatched(videoId, newWatchedValue); return false;});
}

function markVideoWatched(videoId, watched){
	if (!isUserLoggedIn()){
		window.location = "/login";
		return;
	}
	new Ajax.Request('/video_contents/' + videoId + '/watch',
	  {
	    method:'post',
		  parameters: {watched: watched},
	    onSuccess: function(transport){
  	    if(transport.responseText == "true"){
    			if(watched){
    				YAHOO.util.Dom.removeClass('watchedWrapper', 'notWatched'); 
    				changeTooltip('watchedContentLink', 'Watched');
    			}else{
    				YAHOO.util.Dom.addClass('watchedWrapper', 'notWatched'); 
    				changeTooltip('watchedContentLink', 'Click to mark as watched');
    			}
    			addWatchClickListener('watchedContentLink', videoId, !watched);
    	  }else{
    			alert('Error marking video watched: ' + transport.responseText)
    		}
	    },
	    onFailure: function(){ alert('Failed to mark video as watched.') }
	  });
}