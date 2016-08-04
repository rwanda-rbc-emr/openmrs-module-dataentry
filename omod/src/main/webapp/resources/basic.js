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
	var ddose1 = $("#ddose").val();
	var dunits1 = $("#dunits").val();
	var dquantity1 = $("#dquantity").val();
	var dfrequency1 = $("#dfrequency").val();
	var dquantityunits1 = $("#dquantityunits").val();
	var dRoute1 = $("#dRoute").val();
	var dstartDate1 = $("#dstartDate").val();
	var ddiscontinuedDate1 = $("#ddiscontinuedDate").val();
	var dinstructions1 = $("#dinstructions").html();
	
	$('.edit').click(function (e) {
		$("#dstartDate").prop('disabled', true);
	    $("#ddiscontinuedDate").prop('disabled', true);
        $("#editingcreating").attr("value", "edit");
        $("#stop").attr("value", "stop");
        var index = this.id;
        var prefix = index.substring(0, index.indexOf("_"));
        var suffix = index.substring(index.indexOf("_") + 1);
        var varDose = $("#dose_" + suffix).text();
        var drugId = $("#drugId_" + suffix).text().replace(/\s/g, '');
        var varUnits = $("#units_" + suffix).attr("select-id");
        var varFrequency = $("#frequency_" + suffix).attr(
            "select-id");
        var varQuantity = $("#quantity_" + suffix).text();
        var varQuantityUnits = $("#quantityUnits_" + suffix).attr(
            "select-id");
        var varRoute = $("#route_" + suffix).attr("select-id");
        var varStartDate = $("#startDate_" + suffix).text();
        var varDiscDate = $("#discontinuedDate_" + suffix).text();
        var varInstructions = $("#instructions_" + suffix).val();
        var varDrugId = document.getElementById("dname"); //$("#dname").val();
        var varDrugUnitId = document.getElementById("dunits");
        $("#editing").attr("value", suffix);
        //$("#dname").val(drugId);
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
        $("#ddose").attr("value", varDose);
        $("#dunits").val(dunits);
        $("#dquantity").attr("value", varQuantity);
        $("#dfrequency").val(varFrequency);
        $("#dquantityunits").val(varQuantityUnits);
        $("#dRoute").val(varRoute);
        $("#dstartDate").val(varStartDate);
        $("#ddiscontinuedDate").val(varDiscDate);
        $("#dinstructions").html(varInstructions);
        //$("#dinstructions").attr("disabled", true);
        $("#editingcreating").attr("value", "edit");
		$('#edit-dialog-content').dialog();		
		  return false;
	});
	
	$('.stop').click(function (e) {
		$('#stop-modal-content').modal();
		  return false;
	});
	
	$('#create').click(function(e) {
		$("#ddose").attr("value", ddose1);
        $("#dunits").val(dunits1);
        $("#dquantity").attr("value", dquantity1);
        $("#dfrequency").val(dfrequency1);
        $("#dquantityunits").val(dquantityunits1);
        $("#dRoute").val(dRoute1);
        $("#dstartDate").val(dstartDate1);
        $("#ddiscontinuedDate").val(ddiscontinuedDate1);
        $("#dinstructions").html(dinstructions1);
        $("#editingcreating").attr("value", "create");
		$('#edit-dialog-content').dialog();		
		  return false;
	});
	
	$('.popit').click(function(e) {
		$('#rpt-dialog-content').dialog();		
		  return false;
	});
	
	$("#addingi").click(function(e) {
		$("#stop-modal-content").dialog();
	});
	
	$("who").click(function() {
		$("#stop-modal-content").hide();
	});
});