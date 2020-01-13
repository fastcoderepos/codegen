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
  @NotNull(message = "[=key?uncap_first] Should not be null")
  </#if> 
  </#if>
  </#if>
  </#list>
  </#if>
  <#else>
  <#if value.isNullable==false>
  @NotNull(message = "[=key?uncap_first] Should not be null")
  </#if> 
  </#if> 
  <#if value.fieldType?lower_case == "string"> 
  <#if value.length !=0>
  @Length(max = <#if value.length !=0>[=value.length?c]<#else>255</#if>, message = "[=key?uncap_first] must be less than <#if value.length !=0>[=value.length?c]<#else>255</#if> characters")
  </#if>
  </#if>
  private [=value.fieldType] [=key?uncap_first];
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
 
  public [=value.fieldType?cap_first] get[=key?cap_first]() {
  	return [=key?uncap_first];
  }

  public void set[=key?cap_first]([=value.fieldType?cap_first] [=key?uncap_first]){
  	this.[=key?uncap_first] = [=key?uncap_first];
  }
 </#if> 
</#list>
}
