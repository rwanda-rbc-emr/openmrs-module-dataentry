<%@ include file="/WEB-INF/template/include.jsp"%>

<ul>
<c:if test="${model.notInProgram == 'yes'}" >
	<c:if test="${model.patient.age >= 15}">
		<openmrs:hasPrivilege privilege="View Data Entry">
			<c:if test="${model.alreadyAdultInit != 'yes'}">
				<li><a href="module/dataentry/adultEnrollment.form?patientId=${model.patientId}"><spring:message code="dataentry.adultEnroll" /></a></li>
			</c:if>
			<li><a href="module/dataentry/adultFollowup.form?patientId=${model.patientId}"><spring:message code="dataentry.adultFollowup" /></a></li>
		</openmrs:hasPrivilege>
		<openmrs:hasPrivilege privilege="Add Data entry Laboratory examinations">
			<li><a href="module/dataentry/labtest.form?patientId=${model.patientId}&encounterType=adult"><spring:message code="dataentry.labExam" /></a></li>
		</openmrs:hasPrivilege>
	</c:if>

	<c:if test="${model.patient.age < 15}">
		<openmrs:hasPrivilege privilege="View Data Entry">
			<c:if test="${model.alreadyPedInit != 'yes'}">
				<li><a href="module/dataentry/pediatricEnrollment.form?patientId=${model.patientId}"><spring:message code="dataentry.pedEnroll" /></a></li>
			</c:if>
			<li><a href="module/dataentry/pediatricFollowup.form?patientId=${model.patientId}"><spring:message code="dataentry.pedFollowup" /></a></li>
		</openmrs:hasPrivilege>
		<openmrs:hasPrivilege privilege="Add Data entry Laboratory examinations">
			<li><a href="module/dataentry/labtest.form?patientId=${model.patientId}&encounterType=child"><spring:message code="dataentry.labExam" /></a></li>
		</openmrs:hasPrivilege>
	</c:if>
		<openmrs:hasPrivilege privilege="Add Data entry drugs">
			<li><a href="module/dataentry/drugManagement.htm?patientId=${model.patientId}"><spring:message code="dataentry.drugMgt" /></a></li>
		</openmrs:hasPrivilege>
</c:if>

<c:if test="${model.notInProgram != 'yes'}" >
	<p style="font-family: 'Comic sans serif'; color: red;">::.<spring:message code="dataentry.notEnrolledMsg" /></p>
</c:if>
</ul>

<style type="text/css">
	a, a:link, a:hover, a:visited, a:active {
		color: #551a8e;
	}
</style>