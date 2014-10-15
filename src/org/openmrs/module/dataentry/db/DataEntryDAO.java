/**
 * Auto generated file comment
 */
package org.openmrs.module.dataentry.db;

import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.Relationship;

/**
 *
 */
public interface DataEntryDAO {
	
	public Relationship getRelationshipByPatient(Patient patient);
	
	public Obs getObsByPersonConcept(String personId, String conceptId);
	
//	public PatientProgram getPatientProgramByPatient(Patient patient);
	
//	public void saveAdultEnrollmentData(Encounter encounter);
	
//	public Role getRoleByRoleName(String role);
}
