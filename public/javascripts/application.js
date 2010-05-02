// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function changeTooltip(element_id, new_message){
	eval('var tt_var = var_tt_' + element_id)			
	tt_var.destroy();
	tt_var = new YAHOO.widget.Tooltip("tt_" + element_id, { context: element_id, text: new_message });
	eval('var_tt_' + element_id + ' = tt_var')
}