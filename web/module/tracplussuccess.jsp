<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<spring:message code="dataentry.dataEntryCompleteFor" /> : ${patientName} 

<br/>
<br/>

<a href="<openmrs:contextPath/>/patientDashboard.form?patientId=${patientId}">Back to Patient Dashboard</a>