package org.openmrs.module.dataentry.db.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.Relationship;
import org.openmrs.RelationshipType;
import org.openmrs.api.context.Context;
import org.openmrs.module.dataentry.db.DataEntryDAO;

public class DataEntryDAOImpl implements DataEntryDAO {
	protected static final Log log = LogFactory.getLog(DataEntryDAOImpl.class);
	private SessionFactory sessionFactory;

	/**
	 * @return the sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	/**
	 * @param sessionFactory
	 *            the sessionFactory to set
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	@SuppressWarnings("unchecked")
	public Relationship getRelationshipByPatient(Patient patient) {
		StringBuffer sb = new StringBuffer();
		Relationship relationship = null;
		sb.append(" SELECT r.* FROM relationship r WHERE person_b = '"
				+ patient.getPatientId() + "' ");

		Session session = sessionFactory.getCurrentSession();

		List<Relationship> relationships = session
				.createSQLQuery(sb.toString()).addEntity("r",
						Relationship.class).list();
		if (relationships.size() > 0)
			relationship = relationships.get(0);
		
		RelationshipType rt = Context.getPersonService().getRelationshipType(3);		
		@SuppressWarnings("unused")
		List<Relationship> r = Context.getPersonService().getRelationships(null, patient, rt);
		
		return relationship;
	}

	@Override
	public Obs getObsByPersonConcept(String personId, String conceptId) {
		StringBuffer sb = new StringBuffer();
		Session session = sessionFactory.getCurrentSession();
		
		sb.append(" SELECT o.date_started FROM obs o INNER JOIN ");
		sb.append(" SELECT person_id, MAX(date_started) AS start_date FROM obs WHERE concept_id = '" + conceptId + "' AND person_id = '" + personId + "' and voided = 0 GROUP BY person_id) "); 
		sb.append(" AS ob ON o.person_id = ob.person_id AND o.date_started = ob.start_date GROUP BY o.person_id; ");
		
		return (Obs) session.createQuery(sb.toString()).uniqueResult();
	}

}
