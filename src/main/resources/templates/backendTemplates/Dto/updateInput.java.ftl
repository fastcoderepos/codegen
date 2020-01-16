package [=PackageName].application<#if AuthenticationType != "none" && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto;

import java.util.Date;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class Update[=ClassName]Input {

<#list Fields as key,value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  <#if AuthenticationType != "none" && ClassName == AuthenticationTable>  
  <#if AuthenticationFields??>
  <#list AuthenticationFields as authKey,authValue>
  <#if authKey== "Password">
  <#if value.fieldName != authValue.fieldName>
  <#if value.isNullable==false>
  @NotNull(message = "[=value.fieldName] Should not be null")
  </#if> 
  </#if>
  </#if>
  </#list>
  </#if>
  <#else>
  <#if value.isNullable==false>
  @NotNull(message = "[=value.fieldName] Should not be null")
  </#if> 
  </#if> 
  <#if value.fieldType?lower_case == "string"> 
  <#if value.length !=0>
  @Length(max = <#if value.length !=0>[=value.length?c]<#else>255</#if>, message = "[=value.fieldName] must be less than <#if value.length !=0>[=value.length?c]<#else>255</#if> characters")
  </#if>
  </#if>
  private [=value.fieldType] [=value.fieldName];
  </#if>
</#list>
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
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
</#list>

<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
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
}
