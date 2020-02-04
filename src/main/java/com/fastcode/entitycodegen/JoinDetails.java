package com.fastcode.entitycodegen;

public class JoinDetails {

	String joinColumn;
	String joinColumnType;
	Boolean isJoinColumnOptional;
	String referenceColumn;
	String mappedBy;
	String joinEntityName;
	
	public String getJoinEntityName() {
		return joinEntityName;
	}

	public void setJoinEntityName(String joinEntityName) {
		this.joinEntityName = joinEntityName;
	}

	public String getMappedBy() {
		return mappedBy;
	}

	public void setMappedBy(String mappedBy) {
		this.mappedBy = mappedBy;
	}
	
	public String getJoinColumn() {
		return joinColumn;
	}

	public void setJoinColumn(String joinColumn) {
		this.joinColumn = joinColumn;
	}

	public String getReferenceColumn() {
		return referenceColumn;
	}

	public void setReferenceColumn(String referenceColumn) {
		this.referenceColumn = referenceColumn;
	}

	public String getJoinColumnType() { 
		return joinColumnType;
	}

	public void setJoinColumnType(String joinColumnType) {
		this.joinColumnType = joinColumnType;
	}

	public Boolean getIsJoinColumnOptional() {
		return isJoinColumnOptional;
	}

	public void setIsJoinColumnOptional(Boolean isJoinColumnOptional) {
		this.isJoinColumnOptional = isJoinColumnOptional;
	}

}
