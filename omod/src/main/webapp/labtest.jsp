<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<openmrs:require privilege="Add Data entry Laboratory examinations" otherwise="/login.htm" redirect="/module/dataentry/labtest.form"/>

<%@ taglib prefix="springform" uri="/WEB-INF/taglibs/spring-form.tld" %>

<openmrs:htmlInclude file="/moduleResources/dataentry/dataentrystyle.css" />
<openmrs:htmlInclude file="/scripts/calendar/calendar.js" />
<script type="text/javascript">

// lab test arrays
var labTestOptions = new Array();
var labTestIds = new Array();
<c:forEach var="testOption" items="${labTestOptions}">
	labTestOptions.push("<c:out value="${testOption.value}"/>");
	labTestIds.push(<c:out value="${testOption.key}"/>);
</c:forEach>

// provider arrays
var providerOptions = new Array();
var providerIds = new Array();
<c:forEach var="provider" items="${providerOptions}">
	providerOptions.push("<c:out value="${provider.value}"/>");
	providerIds.push(<c:out value="${provider.key}"/>);
</c:forEach>

// location arrays
var locationOptions = new Array();
var locationIds = new Array();
<c:forEach var="location" items="${locationOptions}">
	locationOptions.push("<c:out value="${location.value}"/>");
	locationIds.push(<c:out value="${location.key}"/>);
</c:forEach>

// conceptid for the convset - will ajax this in a bit
var g_convsetId = <c:out value="${labTestConceptId}"/>;
var g_patientId = <c:out value="${patientId}"/>;

jQuery(document).ready(
		function(){
			var height = jQuery("#outerform").height();
			jQuery("#outerform").height(height);
			//jQuery("#outerform").css("z-index",2);
			// the labtest selection element
			var selectElement = jQuery(document.createElement("select")).attr("name","labTestConceptId").attr("id","labtestconceptid");

			var providerSelect = jQuery(document.createElement("select")).attr("name","provider").attr("id","providerid");
			var locationSelect = jQuery(document.createElement("select")).attr("name","location").attr("id","locationid");
			
			// populate the selection list
			for( var j=0; j < labTestOptions.length; j++){
				selectElement.append(jQuery(document.createElement("option")).attr("value",labTestIds[j]).text(labTestOptions[j]));
			}

			// populate providers
			providerSelect.append(jQuery(document.createElement("option")).attr("value",-1).text("--"));
			for( var j=0; j < providerOptions.length; j++){
				providerSelect.append(jQuery(document.createElement("option")).attr("value",providerIds[j]).text(providerOptions[j]));
			}

			// populate locations
			locationSelect.append(jQuery(document.createElement("option")).attr("value",-1).text("--"));
			for( var j=0; j < locationOptions.length; j++){
				locationSelect.append(jQuery(document.createElement("option")).attr("value",locationIds[j]).text(locationOptions[j]));
			}

			
			// insert it into the typeofexamid td tag
			jQuery("#typeofexamid").append(selectElement);

			jQuery("#provider").append(providerSelect);

			jQuery("#location").append(locationSelect);
			
			
			// set a handler to activate the date chooser
			jQuery("#encDateId").focus(
				function(){
					showCalendar(this);
				}
			);
			jQuery("#addtestid").click(
				function(){
					jQuery("#labtestformid").show(200,
						function(){
							jQuery("#addtestid").hide(200);
						});		
				}
			);

			jQuery("#savelabtestbuttonid").click(
					function(){
						var date = jQuery("#encDateId").val();
						var result = jQuery("#resultid").val();
						var patientId = g_patientId;
						var convsetId = g_convsetId;
						var providerId =  jQuery("#providerid").val();
						var locationId =  jQuery("#locationid").val();
						var encounterType = "${encounterType}";
						var labTestConceptId = jQuery("#labtestconceptid").val();
						saveLaboratoryTest(null,patientId,convsetId,null,date,locationId,labTestConceptId, result, providerId, encounterType);
						
						jQuery('#resultid').val("");
						jQuery('#encDateId').val("");
						jQuery('#providerid').find('option:first').attr('selected', 'selected').parent('select');
						jQuery('#locationid').find('option:first').attr('selected', 'selected').parent('select');
						jQuery('#labtestconceptid').find('option:first').attr('selected', 'selected').parent('select');
			});
	});

function saveLaboratoryTest(url, patId, convId, provId, date, locId, conId, result,provId, encounterType){
	//********************whoah dude hard coded url wtf *********************
	$.get("${pageContext.request.contextPath}/module/dataentry/savelabtest.form", {
		patientId :patId,
		convsetId :convId,
		date :date,
		locationId :locId,
		conceptId :conId,
		result :result,
		providerId: provId,
		encounterType : encounterType
	}, function(data) {
		var date = jQuery("date", data).text();
		var test = jQuery("test", data).text();
		var result = jQuery("result", data).text();

		var dateRow = jQuery(document.createElement("tr")).append(jQuery(document.createElement("td")).text(date))
							.append(jQuery(document.createElement("td")).text(test))
								.append(jQuery(document.createElement("td")).text(result));
		jQuery("#resulttableid").append(dateRow);
	}, 'xml');
}

// lets make the server do the work for us and produce test count count count count in xml
</script>
<a
	href="${pageContext.request.contextPath}/patientDashboard.form?patientId=${patient.patientId}"
	style="text-decoration: none;"><openmrs:portlet url="patientHeader"
	id="patientDashboardHeader" patientId="${patient.patientId}" /></a>

<div class="boxHeader"><h2><spring:message code="Laboratory Examination" /></h2></div>

<div class="box">
<div id = "outerform" >
	
	<div id = "labtestformid">
		<table>
			<tr>
			<td><spring:message code="dataentry.type" /></td>
				<td id="typeofexamid"></td>
			</tr>
			<tr>
				<td><spring:message code="dataentry.dateofExam" /></td>
				<td><input id="encDateId" name="dateOfExam" size="11" onchange="CompareDates('<openmrs:datePattern />');"/><span id="msgId"></span></td>
			</tr>
			<tr>
				<td><spring:message code="dataentry.provider" /></td>
				<td id="provider"></td>
			</tr>
			<tr>
				<td><spring:message code="dataentry.location" /></td>
				<td id = "location"></td>
			</tr>
			<tr>
				<td><spring:message code="dataentry.result" /></td>
				<td><input id="resultid" name="result" size="8"/></td>
			</tr>
			<tr>
				<td><button id="savelabtestbuttonid" class="send" >Save Lab Test</button></td>
			</tr>
		</table>
	</div>
</div>

</div>
<!-- 	<p id="addtestid" class="hiddengreenbox"><spring:message code="dataentry.addTest" /></p> --> 

<br/>

<springform:form commandName="laboratoryTest">
	<fieldset><legend ><spring:message code="dataentry.labTests" /></legend>
	<table id="resulttableid">
		
	</table>
	<input type = "hidden" name="encountertype" value="${encounterType}"/>
	</fieldset>
</springform:form>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>
