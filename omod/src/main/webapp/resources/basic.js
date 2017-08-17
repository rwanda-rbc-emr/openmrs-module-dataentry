/*
 * SimpleModal Basic Modal Dialog
 * http://www.ericmmartin.com/projects/simplemodal/
 * http://code.google.com/p/simplemodal/
 *
 * Copyright (c) 2010 Eric Martin - http://ericmmartin.com
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Revision: $Id: basic.js 243 2010-03-15 14:23:14Z emartin24 $
 *
 */

jQuery(function ($) {
	var ddose1 = jQuery("#ddose").val();
	var dunits1 = jQuery("#dunits").val();
	var dquantity1 = jQuery("#dquantity").val();
	var dfrequency1 = jQuery("#dfrequency").val();
	var dquantityunits1 = jQuery("#dquantityunits").val();
	var dRoute1 = jQuery("#dRoute").val();
	var dstartDate1 = jQuery("#dstartDate").val();
	var ddiscontinuedDate1 = jQuery("#ddiscontinuedDate").val();
	var dinstructions1 = jQuery("#dinstructions").html();
	
	jQuery('.edit').click(function (e) {
		//jQuery("#dstartDate").prop('disabled', true);
	    //jQuery("#ddiscontinuedDate").prop('disabled', true);
        jQuery("#editingcreating").attr("value", "edit");
        jQuery("#stop").attr("value", "");
        var index = this.id;
        var prefix = index.substring(0, index.indexOf("_"));
        var suffix = index.substring(index.indexOf("_") + 1);
        var varDose = jQuery("#dose_" + suffix).text();
        var drugId = jQuery("#drugId_" + suffix).text().replace(/\s/g, '');
        var varUnits = jQuery("#units_" + suffix).attr("select-id");
        var varFrequency = jQuery("#frequency_" + suffix).attr(
            "select-id");
        var varQuantity = jQuery("#quantity_" + suffix).text();
        var varQuantityUnits = jQuery("#quantityUnits_" + suffix).attr(
            "select-id");
        var varRoute = jQuery("#route_" + suffix).attr("select-id");
        var varStartDate = jQuery("#startDate_" + suffix).text();
        var varDiscDate = jQuery("#discontinuedDate_" + suffix).text();
        var varInstructions = jQuery("#instructions_" + suffix).val();
        var varDrugId = document.getElementById("dname"); //jQuery("#dname").val();
        var varDrugUnitId = document.getElementById("dunits");
        jQuery("#editing").attr("value", suffix);
        //jQuery("#dname").val(drugId);
        for (var i = 0; i < varDrugId.options.length; i++) {
            if (varDrugId.options[i].value == drugId) {
                varDrugId.selectedIndex = i;
                break;
            }
        }
        for (var i = 0; i < varDrugUnitId.options.length; i++) {
            if (varDrugUnitId.options[i].value == varUnits) {
                varDrugUnitId.selectedIndex = i;
                break;
            }
        }
        jQuery("#ddose").attr("value", varDose);
        jQuery("#dunits").val(dunits);
        jQuery("#dquantity").attr("value", varQuantity);
        jQuery("#dfrequency").val(varFrequency);
        jQuery("#dquantityunits").val(varQuantityUnits);
        jQuery("#dRoute").val(varRoute);
        jQuery("#dstartDate").val(varStartDate);
        jQuery("#ddiscontinuedDate").val(varDiscDate);
        jQuery("#dinstructions").html(varInstructions);
        //jQuery("#dinstructions").attr("disabled", true);
        jQuery("#editingcreating").attr("value", "edit");
		jQuery('#edit-dialog-content').dialog();		
		  return false;
	});
	
	jQuery('.stop').click(function (e) {
        jQuery("#editingcreating").attr("value", "stop");
        var index = this.id;
        var prefix = index.substring(0, index.indexOf("_"));
        var suffix = index.substring(index.indexOf("_") + 1);
        var reasonsId = document.getElementById("reasonsId");
        var varStartDate = jQuery("#stopDate_" + suffix).text();
        var varReasons = jQuery("#discontinuedReason_" + suffix).text();
        jQuery("#stopping").attr("value", suffix);
        jQuery("#stopDateId").attr("value", varStartDate);
        jQuery("#stop").attr("value", "stop");
        for (var i = 0; i < reasonsId.options.length; i++) {
            if (reasonsId.options[i].value == varReasons) {
                reasonsId.selectedIndex = i;
                break;
            }
        }
		jQuery('#stop-modal-content').modal();
		  return false;
	});
	
	jQuery('#create').click(function(e) {
		jQuery("#ddose").attr("value", ddose1);
        jQuery("#dunits").val(dunits1);
        jQuery("#dquantity").attr("value", dquantity1);
        jQuery("#dfrequency").val(dfrequency1);
        jQuery("#dquantityunits").val(dquantityunits1);
        jQuery("#dRoute").val(dRoute1);
        jQuery("#dstartDate").val(dstartDate1);
        jQuery("#ddiscontinuedDate").val(ddiscontinuedDate1);
        jQuery("#dinstructions").html(dinstructions1);
        jQuery("#editingcreating").attr("value", "create");
		jQuery('#edit-dialog-content').dialog();		
		  return false;
	});
	
	jQuery('.popit').click(function(e) {
		jQuery('#rpt-dialog-content').dialog();		
		  return false;
	});
	
	jQuery("#addingi").click(function(e) {
		jQuery("#stop-modal-content").dialog();
	});
	
	jQuery("who").click(function() {
		jQuery("#stop-modal-content").hide();
	});
});