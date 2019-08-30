package [=PackageName].application<#if AuthenticationType== "database" && ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName].Dto;

import java.util.Date;
public class Find[=ClassName]ByIdOutput {

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  private [=value.fieldType] [=value.fieldName];
 </#if> 
</#list>
<#if Audit!false>
  private String creatorUserId;
  private java.util.Date creationTime;
  private String lastModifierUserId;
  private java.util.Date lastModificationTime;
</#if>
<#list Relationship as relationKey,relationValue>
 <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
  <#if CompositeKeyClasses?seq_contains(ClassName)>
 <#list relationValue.joinDetails as joinDetails>
 <#if joinDetails.joinEntityName == relationValue.eName>
 <#if !Fields[joinDetails.joinColumn]?? >
  private [=joinDetails.joinColumnType] [=joinDetails.joinColumn];
 </#if>
</#if>
</#list>
 <#else>
 <#list relationValue.joinDetails as joinDetails>
 <#if joinDetails.joinEntityName == relationValue.eName>
 <#if joinDetails.joinColumn??>
 <#if !Fields[joinDetails.joinColumn]?? >
  private [=joinDetails.joinColumnType] [=joinDetails.joinColumn];
 </#if>
 </#if>
 </#if>
</#list>
 </#if>  
 </#if>

  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
  <#if DescriptiveField[relationValue.eName]??>
  <#if DescriptiveField[relationValue.eName].isPrimaryKey == false>
  private [=DescriptiveField[relationValue.eName].fieldType?cap_first] [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first];
  </#if>
  </#if>
  </#if>
</#list>

<#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
  <#if CompositeKeyClasses?seq_contains(ClassName)>
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
 <#if !Fields[joinDetails.joinColumn]?? >
  <#if joinDetails.joinColumnType?lower_case == "long" || joinDetails.joinColumnType?lower_case == "integer" || joinDetails.joinColumnType?lower_case == "short" || joinDetails.joinColumnType?lower_case == "double" || joinDetails.joinColumnType?lower_case == "string">
  public [=joinDetails.joinColumnType?cap_first] get[=joinDetails.joinColumn?cap_first]() {
  return [=joinDetails.joinColumn];
  }

  public void set[=joinDetails.joinColumn?cap_first]([=joinDetails.joinColumnType?cap_first] [=joinDetails.joinColumn]){
  this.[=joinDetails.joinColumn] = [=joinDetails.joinColumn];
  }
  </#if>
  </#if>
</#if>
</#list>
  <#else>
  <#list relationValue.joinDetails as joinDetails>
 <#if joinDetails.joinEntityName == relationValue.eName>
 <#if joinDetails.joinColumn??>
 <#if !Fields[joinDetails.joinColumn]?? >
  <#if joinDetails.joinColumnType?lower_case == "long" || joinDetails.joinColumnType?lower_case == "integer" || joinDetails.joinColumnType?lower_case == "short" || joinDetails.joinColumnType?lower_case == "double" || joinDetails.joinColumnType?lower_case == "string">
  public [=joinDetails.joinColumnType?cap_first] get[=joinDetails.joinColumn?cap_first]() {
  return [=joinDetails.joinColumn];
  }

  public void set[=joinDetails.joinColumn?cap_first]([=joinDetails.joinColumnType?cap_first] [=joinDetails.joinColumn]){
  this.[=joinDetails.joinColumn] = [=joinDetails.joinColumn];
  }
</#if> 
</#if> 
</#if>
</#if>
</#list>
</#if>
  </#if>

  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
  <#if DescriptiveField[relationValue.eName]??>
  <#if DescriptiveField[relationValue.eName].isPrimaryKey == false>
  public [=DescriptiveField[relationValue.eName].fieldType?cap_first] get[=relationValue.eName][=DescriptiveField[relationValue.eName].fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first];
  }

  public void set[=relationValue.eName][=DescriptiveField[relationValue.eName].fieldName?cap_first]([=DescriptiveField[relationValue.eName].fieldType?cap_first] [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first] = [=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first];
  }
  </#if>
  </#if>
  </#if>
</#list>
<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean"|| value.fieldType?lower_case == "date"|| value.fieldType?lower_case == "string" >
  public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
  </#if> 
</#list>

<#if Audit!false>
  public java.util.Date getCreationTime() {
      return creationTime;
  }

  public void setCreationTime(java.util.Date creationTime) {
      this.creationTime = creationTime;
  }

  public String getLastModifierUserId() {
      return lastModifierUserId;
  }

  public void setLastModifierUserId(String lastModifierUserId) {
      this.lastModifierUserId = lastModifierUserId;
  }

  public java.util.Date getLastModificationTime() {
      return lastModificationTime;
  }

  public void setLastModificationTime(java.util.Date lastModificationTime) {
      this.lastModificationTime = lastModificationTime;
  }

  public String getCreatorUserId() {
      return creatorUserId;
  }

  public void setCreatorUserId(String creatorUserId) {
      this.creatorUserId = creatorUserId;
  }
</#if>
 
}
