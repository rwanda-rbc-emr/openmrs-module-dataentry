package org.openmrs.module.dataentry;

import org.openmrs.DrugOrder;

/*
 * This class is meant to provide DrugOrder method returns which are needed at client level as variables instead
 * to support Tomcat6 container which can't call the methods themselves
 */
public class MoHDrugOrder {
	
	private boolean isActive;

	private String wow = "WOW";

	private DrugOrder drugOrder;

	public MoHDrugOrder(DrugOrder dos) {
		setDrugOrder(dos);
		setActive(dos.isActive());
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public DrugOrder getDrugOrder() {
		return drugOrder;
	}

	public void setDrugOrder(DrugOrder drugOrder) {
		this.drugOrder = drugOrder;
	}
}
