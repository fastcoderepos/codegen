package [=PackageName].application<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>.authorization</#if>.[=AuthenticationTable?lower_case].dto;

import java.util.Date;

public class Find[=AuthenticationTable]By<#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>Name</#if>Output {

 <#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  <#if AuthenticationType == "database" && ClassName == AuthenticationTable>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "Password">
  	<#if value.fieldName != authValue.fieldName>
  private [=value.fieldType] [=value.fieldName];
    </#if>
    </#if>
    </#list>
    </#if>
    <#else>
  private [=value.fieldType] [=value.fieldName];
    </#if> 
 </#if> 
</#list>
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
  <#if AuthenticationType == "database" && ClassName == AuthenticationTable>
  <#if AuthenticationFields??>
  <#list AuthenticationFields as authKey,authValue>
  <#if authKey== "Password">
  <#if value.fieldName != authValue.fieldName>
  public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
  
  </#if>
  </#if>
  </#list>
  </#if>
  <#else>
  public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
  
  </#if> 
  </#if> 
</#list>
}
