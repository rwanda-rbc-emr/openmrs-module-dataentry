<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<openmrs:require privilege="Add Data entry drugs" otherwise="/login.htm" redirect="/module/dataentry/drugManagement.htm"/>

<openmrs:htmlInclude file="/moduleResources/dataentry/demo_page.css" />
<openmrs:htmlInclude file="/moduleResources/dataentry/demo_table.css" />
<openmrs:htmlInclude file="/moduleResources/dataentry/jquery.dataTables.js" />

<openmrs:htmlInclude
	file="/moduleResources/dataentry/jquery.simplemodal.js" />
<openmrs:htmlInclude
	file="/moduleResources/dataentry/jquery.createdit.js" />
<openmrs:htmlInclude file="/moduleResources/dataentry/basic.js" />
<openmrs:htmlInclude file="/moduleResources/dataentry/basic.css" />
<openmrs:htmlInclude file="/scripts/calendar/calendar.js" />
<!-- openmrs:htmlInclude file="/scripts/dojo/dojo.js" /-->
<link href="<%= request.getContextPath() %>/openmrs.css" type="text/css" rel="stylesheet" />


<script type="text/javascript">
	jQuery(document).ready( function() {
		jQuery('.searchBox').hide();
		
		jQuery('#example').dataTable();
		jQuery('.createditdialog-close').trigger('click');

		jQuery('.edit').click( function() {
			var index = this.id;
			var prefix = index.substring(0, index.indexOf("_"));
			var suffix = index.substring(index.indexOf("_") + 1);

			var varDose = jQuery("#dose_" + suffix).text();
			var drugId = jQuery("#drugId_" + suffix).text();
			var varUnits = jQuery("#units_" + suffix).text();
			var varFrequency = jQuery("#frequency_" + suffix).text();
			var varQuantity = jQuery("#quantity_" + suffix).text();
			var varStartDate = jQuery("#startDate_" + suffix).text();
			var varDiscDate = jQuery("#discontinuedDate_" + suffix).text();
			var varInstructions = jQuery("#instructions_" + suffix).val();

			var varDrugId = document.getElementById("dname");//$("#dname").val();
			var varDrugUnitId = document.getElementById("dunits");
			
				jQuery("#editing").attr("value", suffix);

				//$("#dname").val(drugId);
			
				for ( var i = 0; i < varDrugId.options.length; i++) {
					if (varDrugId.options[i].value == drugId) {
						varDrugId.selectedIndex = i;
						break;
					}
				}

				for ( var i = 0; i < varDrugUnitId.options.length; i++) {
					if (varDrugUnitId.options[i].value == varUnits) {
						varDrugUnitId.selectedIndex = i;
						break;
					}
				}

				
				//jQuery("#dname option[text=" + drugId +"]").attr("selected","selected");
				jQuery("#ddose").attr("value", varDose);
				//jQuery("#dunits").attr("value", varUnits);
				jQuery("#dunits option[text=" + varUnits +"]").attr("selected","selected");
				jQuery("#dfrequency").attr("value", varFrequency);
				jQuery("#dquantity").attr("value", varQuantity);
				jQuery("#dstartDate").attr("value", varStartDate);
				jQuery("#ddiscontinuedDate").attr("value", varDiscDate);
				jQuery("#dinstructions").html(varInstructions);
				jQuery("#editingcreating").attr("value", "edit");

				
			});

		jQuery('.stop').click( function() {
			var index = this.id;
			var prefix = index.substring(0, index.indexOf("_"));
			var suffix = index.substring(index.indexOf("_") + 1);
			var reasonsId = document.getElementById("reasonsId");
			var varStartDate = jQuery("#stopDate_" + suffix).text();
			var varReasons = jQuery("#discontinuedReason_" + suffix).text();
			jQuery("#stopping").attr("value", suffix);
			jQuery("#stopDateId").attr("value", varStartDate);
			jQuery("#stop").attr("value", "stop");

			for ( var i = 0; i < reasonsId.options.length; i++) {
				if (reasonsId.options[i].value == varReasons) {
					reasonsId.selectedIndex = i;
					break;
				}
			}
		});

		jQuery('#create').click( function() {
			jQuery("#editingcreating").attr("value", "create");
		});
		jQuery('#relEnc').click(function() {
			jQuery('.searchBox').show();
		});

	});
</script>

<a
	href="${pageContext.request.contextPath}/patientDashboard.form?patientId=${patient.patientId}"
	style="text-decoration: none;"><openmrs:portlet url="patientHeader"
	id="patientDashboardHeader" patientId="${patient.patientId}" /></a>

<div id="dt_example">
<div id="container">
<table cellpadding="0" cellspacing="0" border="0" class="display"
	id="example">
	<thead>
		<tr>
			<th><spring:message code="dataentry.drugId" /></th>
			<th><spring:message code="dataentry.drug" /></th>
			<th><spring:message code="dataentry.dose" /></th>
			<th><spring:message code="dataentry.units" /></th>
			<th><spring:message code="dataentry.frequency" /></th>
			<th><spring:message code="dataentry.quantity" /></th>
			<th><spring:message code="dataentry.startDate" /></th>
			<th><spring:message code="dataentry.stopDate" /></th>
			<th><spring:message code="Stop Reason" /></th>
			<th><spring:message code="dataentry.edit" /></th>
			<th><spring:message code="dataentry.stop" /></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${drugOrders}" var="do" varStatus="num">
			<tr>
				<td>
					<input type="hidden" id="instructions_${do.orderId}" value="${do.instructions}" /> 
					<span id="drugId_${do.orderId}">
						${not empty do.drug.drugId ? do.drug.drugId : '<img id="stop_${do.orderId}" class="stop" src="images/alert.gif"	style="cursor: pointer;" title="Needs to be updated" />'}
					</span>
				</td>
				<td><span id="name_${do.orderId}">${not empty do.drug ? do.drug.name : do.concept.name.name}</span></td>
				<td><span id="dose_${do.orderId}">${do.dose}</span></td>
				<td><span id="units_${do.orderId}">${do.units}</span></td>
				<td><span id="frequency_${do.orderId}">${do.frequency}</span></td>
				<td><span id="quantity_${do.orderId}">${do.quantity}</span></td>
				<td><span id="startDate_${do.orderId}"><openmrs:formatDate
					date="${do.startDate}" type="textbox" /></span></td>
				<td><span id="discontinuedDate_${do.orderId}"><openmrs:formatDate
					date="${do.discontinuedDate}" type="textbox" /></span></td>
				<td><span id="discontinueReason_${do.orderId}">${do.discontinuedReason.name}</span></td>
				<td><img id="edit_${do.orderId}" class="edit"
					src="${pageContext.request.contextPath}/images/edit.gif"
					style="cursor: pointer;" /></td>
				<td><img id="stop_${do.orderId}" class="stop"
					src="${pageContext.request.contextPath}/images/stop.gif"
					style="cursor: pointer;" /></td>
			</tr>
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>			
			<td>
			<button id="create" class="send"><spring:message code="dataentry.create" /></button>
			</td>
			<td></td>
		</tr>
	</tfoot>
</table>
</div>
</div>

<div id="edit-dialog-content">
<form method="post" action="drugManagement.htm?patientId=${patientId}">
<input type="hidden" name="orderId" id="editing" /> <input
	type="hidden" name="editcreate" id="editingcreating" />
	<input type="hidden" name="encounter" value="${encounter.uuid}">
<table>
	<tr>
		<td><spring:message code="dataentry.drug" /></td>
		<td><select name="drugs" id="dname">
			<c:forEach items="${drugs}" var="drug">
				<option value="${drug.drugId}">${drug.name}</option>
			</c:forEach>
		</select></td>
	</tr>
	<tr>
		<td><spring:message code="dataentry.dose" /></td>
		<td><input id="ddose" type="text" name="dose" size="5" /></td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.doseunits" /></td>
		<td>
			<select name="units" id="dunits">
				<c:forEach items="${doseUnits}" var="dose">
					<option value="${dose.uuid}">${dose.names}</option>
				</c:forEach>
			</select>
		</td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.frequency" /></td>
		<td>
			<select name="frequency" id="dfrequency">
				<c:forEach items="${orderFrequencies}" var="dFreq">
					<option value="${dFreq.uuid}">${dFreq.frequencyPerDay}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	
	<tr>
		<td><spring:message code="dataentry.quantity" /></td>
		<td><input id="dquantity" type="text" name="quantity" /></td>
	</tr>
	
	<tr>
		<td><spring:message code="dataentry.quantityunits" /></td>
		<td>
			<select name="quantityUnits" id="dquantityunits">
				<c:forEach items="${quantityUnits}" var="dQtyU">
					<option value="${dQtyU.uuid}">${dQtyU.names}</option>
				</c:forEach>
			</select>
		</td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.startDate" /></td>
		<td><input id="dstartDate" type="text" name="startdate"
			onfocus="showCalendar(this)" class="date" size="11" /> (dd/mm/yyyy)</td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.stopDate" /></td>
		<td><input id="ddiscontinuedDate" type="text" name="stopdate"
			onfocus="showCalendar(this)" class="date" size="11"
			readonly="readonly" /> (dd/mm/yyyy)</td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.route" /></td>
		<td>
			<select name="drugRoute" id="dRoute">
				<c:forEach items="${drugRoutes}" var="dRoute">
					<option value="${dRoute.uuid}">${dRoute.names}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	
	<tr>
		<td valign="top"><spring:message code="Regimen Line" /></td>
		<td>
			<select name="regimenLine">
				<option value="11046">1st Line regimen</option>
				<option value="11047">2nd Line regimen</option>
				<option value="11048">3rd Line Regimen</option>
			</select>
		</td>
	</tr>

	<tr>
		<td valign="top"><spring:message code="dataentry.instructions" /></td>
		<td><textarea name="instructions" cols="50" rows="4"
			id="dinstructions"></textarea></td>
	</tr>

	<tr>
		<td><input type="submit" value="Submit" class="send" /></td>
	</tr>
</table>

</form>
</div>

<div id="stop-modal-content">
<form method="post" action="drugManagement.htm?patientId=${patientId}">
<input type="hidden" name="encounter" value="${encounter.uuid}">
<input type="hidden" name="orderId" id="stopping" /> <input
	type="hidden" name="stopping" id="stop" />
<table>
	<tr>
		<td><spring:message code="dataentry.stopReason" /></td>
		<td><select name="reasons" id="reasonsId">
			<c:forEach items="${reasonStoppedOptions}" var="sr">
				<option value="${sr.key}">${sr.value}</option>
			</c:forEach>
		</select></td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.stopDate" /></td>
		<td><input id="cal" type="text" name="stopDate" id="stopDateId" size="12"
			onfocus="showCalendar(this)" class="date" size="11" /></td>
	</tr>
	<tr>
		<td><input type="submit" value="Update" class="send" /></td>
	</tr>
</table>

</form>
<br />
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>