package [=PackageName].application<#if AuthenticationType != "none" && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto;

import java.util.Date;

public class Get[=RelationEntityName]Output {
 <#list RelationEntityFields as value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  private [=value.fieldType] [=value.fieldName];
 </#if> 
</#list>

<#list Fields as fkey,fvalue>
 <#if fvalue.isPrimaryKey!false>
  <#if fvalue.fieldType?lower_case == "long" || fvalue.fieldType?lower_case == "integer" || fvalue.fieldType?lower_case == "short" || fvalue.fieldType?lower_case == "double" || fvalue.fieldType?lower_case == "boolean" || fvalue.fieldType?lower_case == "date" || fvalue.fieldType?lower_case == "string">
  private [=fvalue.fieldType?cap_first] [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  
  public [=fvalue.fieldType?cap_first] get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  	return [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first]([=fvalue.fieldType?cap_first] [=ClassName?uncap_first][=fvalue.fieldName?cap_first]){
  	this.[=ClassName?uncap_first][=fvalue.fieldName?cap_first] = [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }
  </#if> 
 </#if> 
</#list>
  <#list RelationEntityFields as value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  	return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  	this.[=value.fieldName] = [=value.fieldName];
  }
 </#if> 
</#list>

}
