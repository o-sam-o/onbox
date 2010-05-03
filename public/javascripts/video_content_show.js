function ChangeImdbDialog (container, tabsContainer, searchUrl) {
  var dialog;
  var tabs;

	function init() {
		// Instantiate the Dialog
		dialog = new YAHOO.widget.Dialog(container, 
								{ width : "600px",
								  fixedcenter : true,
								  visible : false,
								  postmethod : 'form',
								  constraintoviewport : true,
								  buttons : [ { text:"Change", handler:handleSubmit, isDefault:true },
							                { text:"Cancel", handler:handleCancel } ]
		});

		// Validate the entries in the form to require that both first and last name are entered
		dialog.validate = validate
		tabs = new YAHOO.widget.TabView(tabsContainer); 
		
		// Render the Dialog
		dialog.render();
		
		//Handle enter being pressed in imdb search field
		var enterListener = new YAHOO.util.KeyListener("search_term", {keys:13}, function(){searchImdb(); return false;});
    enterListener.enable();
		
		// Make visable
		YAHOO.util.Dom.removeClass(container, "hiddenDiv");
	}	
	YAHOO.util.Event.addListener(window, "load", init);
	
	function handleSubmit() {
		this.submit();
	};
	
	function handleCancel() {
		this.cancel();
	};
	
	function validate() {
		var data = this.getData();
		if (data.imdb_id == "") {
			alert("You must provide an IMDB id.");
			return false;
		} else {
			return true;
		}
	};
	
	function changeImdbId() {
		dialog.show()
	}
	this.changeImdbId = changeImdbId;
	
	function reloadFromImdb(imdb_id) {
		if (imdb_id){
			$('imdb_id').setValue(imdb_id);
		}
		if (!dialog.getData().imdb_id){
			//We cant reload from imdb if we dont have an id, show set imdb dialog
			changeImdbId();
			return;
		}
		dialog.submit()
	}
	this.reloadFromImdb = reloadFromImdb;
	
	function searchImdb(){
		var searchTerm = $('search_term').getValue();
		if (searchTerm == ''){
			alert('Please enter a search term');
			return;
		}
		$('imdbSearchResult').innerHTML = '<div style="font-weight:bold;padding: 5px;" align="center">Searching for ' + searchTerm + '...</div>';
		
		new Ajax.Updater('imdbSearchResult', searchUrl, 
		                 { method: 'get', parameters: {search_term: searchTerm}, evalScripts: true });
	}
	this.searchImdb = searchImdb;
  
}