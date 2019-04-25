package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;
public class Update[=ClassName]Input {

<#list Fields as key,value>
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
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
 private [=relationValue.joinColumnType] [=relationValue.joinColumn];
</#if>
</#list>


<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
<#if relationValue.joinColumnType?lower_case == "long">
  public Long get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first](Long [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
</#if> 
</#if>
</#list>
<#list Fields as key,value>
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
