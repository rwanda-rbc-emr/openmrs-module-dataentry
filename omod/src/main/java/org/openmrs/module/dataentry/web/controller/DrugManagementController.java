/**
 * Auto generated file comment
 */
package org.openmrs.module.dataentry.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.exception.ConstraintViolationException;
import org.openmrs.Concept;
import org.openmrs.Drug;
import org.openmrs.DrugOrder;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderFrequency;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.api.APIException;
import org.openmrs.api.ConceptService;
import org.openmrs.api.EncounterService;
import org.openmrs.api.OrderService;
import org.openmrs.api.ValidationException;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataentry.Constants;
import org.openmrs.module.dataentry.utils.Utils;
import org.openmrs.module.mohorderentrybridge.MoHConcept;
import org.openmrs.module.mohorderentrybridge.MoHDrugOrder;
import org.openmrs.module.mohorderentrybridge.MoHOrderFrequency;
import org.openmrs.module.mohorderentrybridge.api.MoHOrderEntryBridgeService;
import org.openmrs.web.WebConstants;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.ParameterizableViewController;

/**
 *
 */
@SuppressWarnings("unused")
public class DrugManagementController extends ParameterizableViewController {

	private Log log = LogFactory.getLog(getClass());

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession httpSession = request.getSession();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		ModelAndView mav = new ModelAndView();
		EncounterService encounterService = Context.getEncounterService();
		ConceptService conceptService = Context.getConceptService();
		OrderService orderService = Context.getOrderService();
		List<Drug> drugs = Context.getConceptService().getAllDrugs();
		Encounter encounter = null;

		Patient patient = null;
		if (request.getParameter("patientId") != null
				&& !request.getParameter("patientId").equals("")) {
			patient = Context.getPatientService().getPatient(
					Integer.valueOf(request.getParameter("patientId")));
		}
		if (request.getParameter("editcreate") != null
				&& !request.getParameter("editcreate").equals("")
				&& patient != null) {
			if (request.getParameter("editcreate").equals("create")) {
				try {
					DrugOrder drugOrder = new DrugOrder();
					Drug drug = conceptService.getDrug(Integer.valueOf(request
							.getParameter("drugs")));
					String startDateStr = ServletRequestUtils.getStringParameter(
							request, "startdate", null);
					String stopDateStr = ServletRequestUtils.getStringParameter(
							request, "stopdate", null);
					OrderType orderType = orderService
							.getOrderType(Constants.DRUG_ORDER_TYPE);

					drugOrder.setCreator(Context.getAuthenticatedUser());
					drugOrder.setConcept(drug.getConcept());
					drugOrder.setOrderType(orderType);
					drugOrder.setDosingInstructions(request.getParameter("instructions"));
					drugOrder.setDateCreated(new Date());
					drugOrder.setPatient(patient);
					drugOrder.setDrug(drug);
					if (request.getParameter("regimenLine") != null
							&& !request.getParameter("regimenLine").equals(null)) {
						drugOrder.setAccessionNumber(request.getParameter("regimenLine"));
					}
					if (request.getParameter("dose") != null
							&& !request.getParameter("dose").equals(""))
						drugOrder.setDose(Double.valueOf(request
								.getParameter("dose")));
					drugOrder.setFrequency(Context.getOrderService().getOrderFrequencyByUuid(request.getParameter("frequency")));
					drugOrder.setDoseUnits(Context.getConceptService().getConceptByUuid(request.getParameter("units")));
					if (request.getParameter("quantity") != null
							&& !request.getParameter("quantity").equals("")) {
						drugOrder.setQuantity(Double.valueOf(request
								.getParameter("quantity")));
						drugOrder.setQuantityUnits(Context.getConceptService().getConceptByUuid(request.getParameter("quantityUnits")));
					}
					drugOrder.setNumRefills(Context.getService(MoHOrderEntryBridgeService.class).getDrugOrdersByPatient(patient).size());
					
					drugOrder.setCareSetting(Context.getOrderService().getCareSettingByName("Inpatient"));//TODO how can i do this better instead of hard coding it to inpatient
					drugOrder.setRoute(Context.getConceptService().getConceptByUuid(request.getParameter("drugRoute")));
					if (!startDateStr.equals("") && startDateStr != null) {
						Date startDate = sdf.parse(startDateStr);
						Date stopDate = sdf.parse(stopDateStr);
						if(startDate.after(new Date())) {
							drugOrder.setUrgency(Order.Urgency.ON_SCHEDULED_DATE);
							drugOrder.setScheduledDate(startDate);
						} else {
							drugOrder.setDateActivated(startDate);
						}
						Encounter enc = setDrugOrderEncounterAndOrdererAndSaveOrder(request, orderService, patient, drugOrder,
								startDate);
						mav.addObject("msg",
								"An order has been created successfully!");
						mav.addObject("encounter", enc);
					} else {
						httpSession.setAttribute(WebConstants.OPENMRS_ERROR_ATTR,
								"You need to enter the start date!");
					}
				} catch (ValidationException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				} catch (APIException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				} catch (ConstraintViolationException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				}
			}

		}

		// Editing an order
		if (request.getParameter("editcreate") != null
				&& !request.getParameter("editcreate").equals("")
				&& patient != null) {
			String odaId = request.getParameter("orderId");
			DrugOrder drugOrder = StringUtils.isBlank(odaId) ? null : (DrugOrder) orderService.getOrder(Integer.valueOf(odaId));
			Drug drug = conceptService.getDrug(Integer.valueOf(request
					.getParameter("drugs")));
			Date startDate = new Date();
			if (request.getParameter("editcreate").equals("edit") && drugOrder != null) {
				try {
					Date stopDate = null;
					
					DrugOrder drugOrder1 = drugOrder.cloneForRevision();
					if (request.getParameter("startdate") != null
							&& !request.getParameter("startdate").equals("")) {
						String strDate1 = request.getParameter("startdate");
						startDate = sdf.parse(strDate1);
						String strDate2 = request.getParameter("stopdate");
						stopDate = sdf.parse(strDate1);
					}

					drugOrder1.setConcept(drug.getConcept());
					drugOrder1.setDosingInstructions(request.getParameter("instructions"));
					drugOrder1.setDateCreated(new Date());
					drugOrder1.setPatient(patient);
					drugOrder1.setDrug(drug);

					if (request.getParameter("dose") != null
							&& !request.getParameter("dose").equals(""))
						drugOrder1.setDose(Double.valueOf(request
								.getParameter("dose")));

					String freqUuid = request.getParameter("frequency");
					OrderFrequency freq = orderService.getOrderFrequencyByUuid(freqUuid);
					
					drugOrder1.setFrequency(freq);
					drugOrder1.setDoseUnits(Context.getConceptService().getConceptByUuid(request.getParameter("units")));

					if (request.getParameter("quantity") != null
							&& !request.getParameter("quantity").equals(""))
						drugOrder1.setQuantity(Double.valueOf(request.getParameter("quantity")));
					drugOrder1.setDateChanged(new Date());
					/*if(startDate.after(new Date())) {
						drugOrder.setUrgency(Order.Urgency.ON_SCHEDULED_DATE);
						drugOrder.setScheduledDate(startDate);
					} else {
						drugOrder.setDateActivated(startDate);
					}
					drugOrder1.setAutoExpireDate(stopDate);*/
					
					Encounter enc = setDrugOrderEncounterAndOrdererAndSaveOrder(request, orderService, patient, drugOrder1,
							startDate);
					mav.addObject("msg", "An order has been updated successfully!");
					mav.addObject("encounter", enc);
				} catch (APIException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				}
			} else if (request.getParameter("editcreate").equals("start")) {
				
			} else if (request.getParameter("editcreate").equals("delete")) {
				orderService.purgeOrder(drugOrder);
			}
		}

		// Stopping an order
		if (request.getParameter("stopping") != null
				&& !request.getParameter("stopping").equals("")) {
			if (request.getParameter("stopping").equals("stop")) {
				try {
					Order order = orderService.getOrder(Integer.valueOf(request
							.getParameter("orderId")));
					Concept concept = conceptService.getConcept(Integer
							.valueOf(request.getParameter("reasons")));
					Date date = sdf.parse(request.getParameter("stopDate"));
					Context.getOrderService().discontinueOrder(order, concept, date, Context.getService(MoHOrderEntryBridgeService.class).getFirstCurrentProvider(), order.getEncounter());
					
					orderService.saveOrder(order, null);
					mav.addObject("msg", "An order has been stopped successfully!");
				} catch (APIException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				} catch (ParseException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				} catch (IllegalArgumentException e) {
					request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR, e.getMessage());
				}
			}

		}

		List<MoHDrugOrder> drugOrders = new ArrayList<MoHDrugOrder>();
		List<MoHOrderFrequency> orderFrequencies = Context.getService(MoHOrderEntryBridgeService.class).getMoHOrderFrequencies(false);//exclude retired
		List<MoHConcept> doseUnits = Context.getService(MoHOrderEntryBridgeService.class).convertConceptsListToMoHConceptsList(Context.getOrderService().getDrugDosingUnits());
		List<MoHConcept> quantityUnits = Context.getService(MoHOrderEntryBridgeService.class).convertConceptsListToMoHConceptsList(Context.getOrderService().getDrugDispensingUnits());
		List<MoHConcept> drugRoutes = Context.getService(MoHOrderEntryBridgeService.class).convertConceptsListToMoHConceptsList(Context.getOrderService().getDrugRoutes());
		
		if (patient != null) {
			drugOrders = Context.getService(MoHOrderEntryBridgeService.class).getMoHDrugOrdersByPatient(patient);
			mav.addObject("patient", patient);
		}
		mav.addObject("drugOrders", drugOrders);
		mav.addObject("reasonStoppedOptions",
				Utils.createCodedOptions(Constants.REASON_ORDER_STOPPED));
		mav.addObject("drugs", drugs);
		mav.addObject("orderFrequencies", orderFrequencies);
		mav.addObject("doseUnits", doseUnits);
		mav.addObject("patientId", patient.getPatientId());
		mav.addObject("quantityUnits", quantityUnits);
		mav.addObject("encounter", encounter);
		mav.addObject("drugRoutes", drugRoutes);
		mav.setViewName(getViewName());

		return mav;
	}

	private Encounter setDrugOrderEncounterAndOrdererAndSaveOrder(HttpServletRequest request, OrderService orderService,
			Patient patient, DrugOrder drugOrder, Date startDate) {
		Encounter enc1 = Context.getEncounterService().getEncounterByUuid(request.getParameter("encounter"));
		Encounter enc = Utils.createEncounter(startDate, Context.getAuthenticatedUser(),
				Context.getLocationService().getDefaultLocation(), patient, enc1 == null ? Context.getEncounterService().getEncounterType(Constants.ADULT_RETURN) : enc1.getEncounterType(), new ArrayList<Obs>());
		if(enc != null) {
			Context.getEncounterService().saveEncounter(enc);
		}
		drugOrder.setEncounter(enc);
		drugOrder.setOrderer(Context.getService(MoHOrderEntryBridgeService.class).getFirstCurrentProvider());
		orderService.saveOrder(drugOrder, null);
		
		return enc;
	}
}
