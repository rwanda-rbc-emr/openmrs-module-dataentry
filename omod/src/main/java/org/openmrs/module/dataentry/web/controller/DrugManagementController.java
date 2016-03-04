/**
 * Auto generated file comment
 */
package org.openmrs.module.dataentry.web.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.exception.ConstraintViolationException;
import org.openmrs.CareSetting;
import org.openmrs.Concept;
import org.openmrs.Drug;
import org.openmrs.DrugOrder;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderFrequency;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.Provider;
import org.openmrs.api.APIException;
import org.openmrs.api.ConceptService;
import org.openmrs.api.EncounterService;
import org.openmrs.api.OrderService;
import org.openmrs.api.ValidationException;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataentry.Constants;
import org.openmrs.module.dataentry.utils.Utils;
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
					Order order = new Order();
					Drug drug = conceptService.getDrug(Integer.valueOf(request
							.getParameter("drugs")));
					String startDateStr = ServletRequestUtils.getStringParameter(
							request, "startdate", null);

					OrderType orderType = orderService
							.getOrderType(Constants.DRUG_ORDER_TYPE);

					drugOrder.setCreator(Context.getAuthenticatedUser());
					drugOrder.setConcept(drug.getConcept());
					drugOrder.setOrderType(orderType);
					drugOrder.setInstructions(request.getParameter("instructions"));
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
					CareSetting setting = null;
					for(CareSetting cs : Context.getOrderService().getCareSettings(false)) {
						if(cs.getCareSettingType().equals(CareSetting.CareSettingType.OUTPATIENT)) {
							setting = cs;
							drugOrder.setNumRefills(getDrugOrdersByPatient(patient).size());
							break;
						}
					}
					drugOrder.setCareSetting(setting);
					drugOrder.setRoute(Context.getConceptService().getConceptByUuid(request.getParameter("drugRoute")));
					if (!startDateStr.equals("") && startDateStr != null) {
						Date startDate = sdf.parse(startDateStr);
						drugOrder.setDateActivated(startDate);
						Encounter enc1 = Context.getEncounterService().getEncounterByUuid(request.getParameter("encounter"));
						Encounter enc = Utils.createEncounter(startDate, Context.getAuthenticatedUser(),
								Context.getLocationService().getDefaultLocation(), patient, enc1 == null ? Context.getEncounterService().getEncounterType(Constants.ADULT_RETURN) : enc1.getEncounterType(), new ArrayList<Obs>());
						if(enc != null) {
							Context.getEncounterService().saveEncounter(enc);
						}
						drugOrder.setEncounter(enc);

						Collection<Provider> activPproviders = Context.getProviderService().getProvidersByPerson(Context.getAuthenticatedUser().getPerson());
						
						for (Provider prov : activPproviders) {
							drugOrder.setOrderer(prov);
							orderService.saveOrder(drugOrder, null);
							break;
						}
						mav.addObject("msg",
								"An order has been created successfully!");
						mav.addObject("encounter", enc);
					} else {
						httpSession.setAttribute(WebConstants.OPENMRS_ERROR_ATTR,
								"You need to enter the start date!");
					}
				} catch (ValidationException e) {
					mav.addObject("msg", e.getMessage());
				} catch (APIException e) {
					mav.addObject("msg", e.getMessage());
				} catch (ConstraintViolationException e) {
					mav.addObject("msg", e.getMessage());
				}
			}

		}

		// Editing an order
		if (request.getParameter("editcreate") != null
				&& !request.getParameter("editcreate").equals("")
				&& patient != null) {
			if (request.getParameter("editcreate").equals("edit")) {
				DrugOrder drugOrder = (DrugOrder) orderService.getOrder(Integer.valueOf(request.getParameter("orderId")));
				Order order = orderService.getOrder(Integer.valueOf(request
						.getParameter("orderId")));

				Drug drug = conceptService.getDrug(Integer.valueOf(request
						.getParameter("drugs")));

				// editing the date from the form to get this format dd/MM/yyyy
				if (request.getParameter("startdate") != null
						&& !request.getParameter("startdate").equals("")) {
					String strDate1 = request.getParameter("startdate");

					Date startDate = sdf.parse(strDate1);
					drugOrder.setDateActivated(startDate);
				}

				drugOrder.setConcept(drug.getConcept());
				drugOrder.setInstructions(request.getParameter("instructions"));
				drugOrder.setDateCreated(new Date());
				drugOrder.setPatient(patient);
				drugOrder.setDrug(drug);

				if (request.getParameter("dose") != null
						&& !request.getParameter("dose").equals(""))
					drugOrder.setDose(Double.valueOf(request
							.getParameter("dose")));

				drugOrder.setFrequency(Context.getOrderService().getOrderFrequencyByUuid(request.getParameter("frequency")));
				drugOrder.setDoseUnits(Context.getConceptService().getConceptByUuid(request.getParameter("units")));

				if (request.getParameter("quantity") != null
						&& !request.getParameter("quantity").equals(""))
					drugOrder.setQuantity(Double.valueOf(request
							.getParameter("quantity")));

				orderService.saveOrder(drugOrder, null);
				mav.addObject("msg", "An order has been updated successfully!");
			}
		}

		// Stopping an order
		if (request.getParameter("stopping") != null
				&& !request.getParameter("stopping").equals("")) {
			if (request.getParameter("stopping").equals("stop")) {
				Order order = orderService.getOrder(Integer.valueOf(request
						.getParameter("orderId")));
				Concept concept = conceptService.getConcept(Integer
						.valueOf(request.getParameter("reasons")));
				Date date = sdf.parse(request.getParameter("stopDate"));
				Collection<Provider> activPproviders = Context.getProviderService().getProvidersByPerson(Context.getAuthenticatedUser().getPerson());
				
				for (Provider prov : activPproviders) {
					Context.getOrderService().discontinueOrder(order, concept, date, prov, order.getEncounter());
			    }
				
				orderService.saveOrder(order, null);
				mav.addObject("msg", "An order has been stopped successfully!");
			}

		}

		List<DrugOrder> drugOrders = new ArrayList<DrugOrder>();
		List<OrderFrequency> orderFrequencies = Context.getOrderService().getOrderFrequencies(false);//exclude retired
		List<Concept> doseUnits = Context.getOrderService().getDrugDosingUnits();
		List<Concept> quantityUnits = Context.getOrderService().getDrugDispensingUnits();
		List<Concept> drugRoutes = Context.getOrderService().getDrugRoutes();
		
		if (patient != null) {
			drugOrders = getDrugOrdersByPatient(patient);
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
	
	private List<DrugOrder> getDrugOrdersByPatient(Patient patient) {
		List<Order> orderList = Context.getOrderService().getAllOrdersByPatient(patient);
		List<DrugOrder> drugOrders = new ArrayList<DrugOrder>();
		for(Order order: orderList) {
			if("org.openmrs.DrugOrder".equals(order.getOrderType().getJavaClassName())) {
				drugOrders.add((DrugOrder) order);
			}
		}
		return drugOrders;
	}
}
