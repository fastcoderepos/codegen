package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;

public class Get[=RelationEntityName]Output {
 <#list RelationEntityFields as value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  private Long [=value.fieldName];
  <#elseif value.fieldType?lower_case == "boolean">
  private Boolean [=value.fieldName];
  <#elseif value.fieldType?lower_case == "date">
  private Date [=value.fieldName];
  <#elseif value.fieldType?lower_case == "string">
  private String [=value.fieldName];
  </#if>
</#list>

<#list Fields as fkey,fvalue>
 <#if fvalue.isPrimaryKey?string('true','false') == "true" >
 <#if fvalue.fieldType?lower_case == "long" || fvalue.fieldType?lower_case == "int">
  private Long [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  
  public Long get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Long [=ClassName?lower_case][=fvalue.fieldName?cap_first]){
  this.[=ClassName?lower_case][=fvalue.fieldName?cap_first] = [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "boolean">
  private Boolean [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  
  public Boolean get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Boolean [=ClassName?lower_case][=fvalue.fieldName?cap_first]){
  this.[=ClassName?lower_case][=fvalue.fieldName?cap_first] = [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "date">
  private Date [=ClassName?lower_case][=fvalue.fieldName];
  
  public Date get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Date [=ClassName?lower_case][=fvalue.fieldName?cap_first]){
  this.[=ClassName?lower_case][=fvalue.fieldName?cap_first] = [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "string">
  private String [=ClassName?lower_case][=fvalue.fieldName];
  
  public String get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](String [=ClassName?lower_case][=fvalue.fieldName?cap_first]){
  this.[=ClassName?lower_case][=fvalue.fieldName?cap_first] = [=ClassName?lower_case][=fvalue.fieldName?cap_first];
  }
 </#if> 
 </#if>
</#list>
  
  <#list RelationEntityFields as value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  public Long get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Long [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "boolean">
  public Boolean get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Boolean [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "date">
  public Date get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Date [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "string">
  public String get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](String [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 </#if> 
</#list>

}
