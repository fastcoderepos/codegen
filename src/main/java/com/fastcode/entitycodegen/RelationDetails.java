package com.fastcode.entitycodegen;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

@Component
public class RelationDetails {

	String cName;
	String relation;
	String joinTable;
	String eName;
	String eModuleName;
	String fName;
	Boolean isParent=false;
	List<JoinDetails> joinDetails = new ArrayList<JoinDetails>();
	List<FieldDetails> fDetails = new ArrayList<>();

	public List<JoinDetails> getJoinDetails() {
		return joinDetails;
	}

	public void setJoinDetails(List<JoinDetails> joinDetails) {
		this.joinDetails = joinDetails;
	}
	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public String getcName() {
		return cName;
	}

	public void setcName(String cName) {
		this.cName = cName;
	}

	public String geteName() {
		return eName;
	}

	public void seteName(String eName) {
		this.eName = eName;
	}

	public String getfName() {
		return fName;
	}

	public void setfName(String fName) {
		this.fName = fName;
	}

	public String getJoinTable() {
		return joinTable;
	}

	public void setJoinTable(String joinTable) { 
		this.joinTable = joinTable;
	}

	public Boolean getIsParent() {
		return isParent;
	}

	public void setIsParent(Boolean isParent) {
		this.isParent = isParent;
	}

	public List<FieldDetails> getfDetails() {
		return fDetails;
	}

	public void setfDetails(List<FieldDetails> fDetails) {
		this.fDetails = fDetails;
	}

	public String geteModuleName() {
		return eModuleName; 
	}

	public void seteModuleName(String eModuleName) {
		this.eModuleName = eModuleName;
	}

}
