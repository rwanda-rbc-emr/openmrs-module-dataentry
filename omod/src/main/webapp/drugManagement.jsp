<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<openmrs:require privilege="Add Data entry drugs" otherwise="/login.htm" redirect="/module/dataentry/drugManagement.htm"/>

<openmrs:htmlInclude file="/moduleResources/dataentry/demo_page.css" />
<openmrs:htmlInclude file="/moduleResources/dataentry/demo_table.css" />
<openmrs:htmlInclude
	file="/moduleResources/dataentry/jquery.dataTables.js" />

<openmrs:htmlInclude
	file="/moduleResources/dataentry/jquery.simplemodal.js" />
<openmrs:htmlInclude
	file="/moduleResources/dataentry/jquery.createdit.js" />
<openmrs:htmlInclude file="/moduleResources/dataentry/basic.js" />
<openmrs:htmlInclude file="/moduleResources/dataentry/basic.css" />
<openmrs:htmlInclude file="/scripts/calendar/calendar.js" />
<openmrs:htmlInclude file="/scripts/dojo/dojo.js" />

<openmrs:portlet url="patientHeader" id="patientDashboardHeader" patientId="${patient.patientId}" />

<div id="dt_example">
<div id="container">
<table cellpadding="0" cellspacing="0" border="0" class="display"
	id="example">
	<thead>
		<tr>
			<th><spring:message code="dataentry.drugId" /></th>
			<th><spring:message code="dataentry.drug" /></th>
			<th><spring:message code="dataentry.dose" /></th>
			<th><spring:message code="dataentry.doseunits" /></th>
			<th><spring:message code="dataentry.frequency" /></th>
			<th><spring:message code="dataentry.quantity" /></th>
			<th><spring:message code="dataentry.quantityunits" /></th>
			<th><spring:message code="dataentry.route" /></th>
			<th><spring:message code="dataentry.startDate" /></th>
			<th><spring:message code="dataentry.stopDate" /></th>
			<th><spring:message code="dataentry.reviseOrClone" /></th>
			<th><spring:message code="dataentry.stop" /></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${drugOrders}" var="do" varStatus="num">
			<tr>
				<td>
					<input type="hidden" id="instructions_${do.drugOrder.orderId}" value="${do.drugOrder.instructions}" /> 
					<span id="drugId_${do.drugOrder.orderId}">
						<img alt="${do.drugOrder.orderId}" title="" />
					</span>
				</td>
				<td><span id="name_${do.drugOrder.orderId}">${not empty do.drugOrder.drug ? do.drugOrder.drug.name : do.drugOrder.concept.name.name}</span></td>
				<td><span id="dose_${do.drugOrder.orderId}">${do.drugOrder.dose}</span></td>
				<td><span id="units_${do.drugOrder.orderId}" select-id="${do.drugOrder.doseUnits.uuid}">${do.doseUnitsName}</span></td>
				<td><span id="frequency_${do.drugOrder.orderId}" select-id="${do.drugOrder.frequency.uuid}">${do.frequency}</span></td>
				<td><span id="quantity_${do.drugOrder.orderId}">${do.drugOrder.quantity}</span></td>
				<td><span id="quantityUnits_${do.drugOrder.orderId}"select-id="${do.drugOrder.quantityUnits.uuid}">${do.quantityUnitsName}</span></td>
				<td><span id="route_${do.drugOrder.orderId}"select-id="${do.drugOrder.route.uuid}">${do.routeName}</span></td>
				<td><span id="startDate_${do.drugOrder.orderId}"><openmrs:formatDate
					date="${do.startDate}" type="textbox" /></span></td>
				<td><span id="discontinuedDate_${do.drugOrder.orderId}"><openmrs:formatDate
					date="${do.stopDate}" type="textbox" /></span></td>
				<td>
					<c:choose>
						<c:when test="${do.isActive ne null && do.isActive eq true}">
							<img id="edit_${do.drugOrder.orderId}" class="edit"
								src="${pageContext.request.contextPath}/images/edit.gif"
								style="cursor: pointer;" />
							</c:when>
						<c:otherwise>
							<!-- TODO do what? -->
						</c:otherwise>
					</c:choose>	
				</td>
				<td>
					<c:choose>
						<c:when test="${do.isActive ne null && do.isActive eq true}">
							<img id="stop_${do.drugOrder.orderId}" class="stop"
								src="${pageContext.request.contextPath}/images/stop.gif"
								style="cursor: pointer;" />
						</c:when>
						<c:otherwise>
							<!-- TODO do what? -->
						</c:otherwise>
					</c:choose>
				</td>	
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
					<option value="${dose.concept.uuid}">${dose.name}</option>
				</c:forEach>
			</select>
		</td>
	</tr>

	<tr>
		<td><spring:message code="dataentry.frequency" /></td>
		<td>
			<select name="frequency" id="dfrequency">
				<c:forEach items="${orderFrequencies}" var="dFreq">
					<option value="${dFreq.orderFrequency.uuid}">${dFreq.name}</option>
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
					<option value="${dQtyU.concept.uuid}">${dQtyU.name}</option>
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
					<option value="${dRoute.concept.uuid}">${dRoute.name}</option>
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

<script type="text/javascript">
var $dm = jQuery.noConflict();

$dm(document).ready( function() {
	$dm('.searchBox').hide();
	$dm(".createditdialog-close").trigger("click");
	$dm('#example').dataTable();
	$dm('.edit').click( function() {
		$dm("#editingcreating").attr("value", "edit");
		$dm("#stop").attr("value", "stop");
		
		var index = this.id;
		var prefix = index.substring(0, index.indexOf("_"));
		var suffix = index.substring(index.indexOf("_") + 1);
		var varDose = $dm("#dose_" + suffix).text();
		var drugId = $dm("#drugId_" + suffix).text().replace(/\s/g, '');
		var varUnits = $dm("#units_" + suffix).attr("select-id");
		var varFrequency = $dm("#frequency_" + suffix).attr("select-id");
		var varQuantity = $dm("#quantity_" + suffix).text();
		var varQuantityUnits = $dm("#quantityUnits_" + suffix).attr("select-id");
		var varRoute = $dm("#route_" + suffix).attr("select-id");
		var varStartDate = $dm("#startDate_" + suffix).text();
		var varDiscDate = $dm("#discontinuedDate_" + suffix).text();
		var varInstructions = $dm("#instructions_" + suffix).val();
		var varDrugId = document.getElementById("dname");//$("#dname").val();
		var varDrugUnitId = document.getElementById("dunits");
		
			$dm("#editing").attr("value", suffix);
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
			
			$dm("#ddose").attr("value", varDose);
			$dm("#dunits").val(varUnits);
			$dm("#dquantity").attr("value", varQuantity);
			$dm("#dfrequency").val(varFrequency);
			$dm("#dquantityunits").val(varQuantityUnits);
			$dm("#dRoute").val(varRoute);
			$dm("#dstartDate").val(varStartDate);
			$dm("#ddiscontinuedDate").val(varDiscDate);
			$dm("#dinstructions").html(varInstructions);
			//$dm("#dinstructions").attr("disabled", true);
			$dm("#editingcreating").attr("value", "edit");
		});
	
	$dm('.stop').click( function() {
		$dm("#editingcreating").attr("value", "");
		var index = this.id;
		var prefix = index.substring(0, index.indexOf("_"));
		var suffix = index.substring(index.indexOf("_") + 1);
		var reasonsId = document.getElementById("reasonsId");
		var varStartDate = $dm("#stopDate_" + suffix).text();
		var varReasons = $dm("#discontinuedReason_" + suffix).text();
		$dm("#stopping").attr("value", suffix);
		$dm("#stopDateId").attr("value", varStartDate);
		$dm("#stop").attr("value", "stop");
		for ( var i = 0; i < reasonsId.options.length; i++) {
			if (reasonsId.options[i].value == varReasons) {
				reasonsId.selectedIndex = i;
				break;
			}
		}
	});
	$dm('#create').click( function() {
		$dm("#editingcreating").attr("value", "create");
		$dm("#stop").attr("value", "");
	});
	$dm('.start').click( function() {
		var id = this.id.replace("start_", "");
		$dm("#editingcreating").attr("value", "start");
		$dm("#stop").attr("value", "");
	});
	$dm('.delete').click( function() {
		var id = this.id.replace("delete_", "");
		$dm("#editingcreating").attr("value", "delete");
		$dm("#stop").attr("value", "");
	});
	$dm('#relEnc').click(function() {
		$dm('.searchBox').show();
	});
});

</script>

<%@ include file="/WEB-INF/template/footer.jsp"%>
