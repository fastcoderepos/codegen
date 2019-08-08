package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;
public class Update[=ClassName]Input {

<#list Fields as key,value>
 <#if value.isAutogenerated == false>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  private [=value.fieldType] [=value.fieldName];
 </#if> 
 </#if> 
</#list>
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
 <#if CompositeKeyClasses?seq_contains(ClassName)>
 <#if !Fields[relationValue.joinColumn]?? >
 private [=relationValue.joinColumnType] [=relationValue.joinColumn];
 </#if>
 <#else>
 <#if relationValue.joinColumn??>
 private [=relationValue.joinColumnType] [=relationValue.joinColumn];
 </#if>
 </#if>
</#if>
</#list>

<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
  <#if CompositeKeyClasses?seq_contains(ClassName)>
  <#if !Fields[relationValue.joinColumn]?? >
  <#if relationValue.joinColumnType?lower_case == "long" || relationValue.joinColumnType?lower_case == "integer" || relationValue.joinColumnType?lower_case == "short" || relationValue.joinColumnType?lower_case == "double" || relationValue.joinColumnType?lower_case == "string">
  public [=relationValue.joinColumnType?cap_first] get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first]([=relationValue.joinColumnType?cap_first] [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
  </#if>
  </#if>
  <#else>
  <#if relationValue.joinColumn??>
  <#if relationValue.joinColumnType?lower_case == "long" || relationValue.joinColumnType?lower_case == "integer" || relationValue.joinColumnType?lower_case == "short" || relationValue.joinColumnType?lower_case == "double" || relationValue.joinColumnType?lower_case == "string">
  public [=relationValue.joinColumnType?cap_first] get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first]([=relationValue.joinColumnType?cap_first] [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
</#if> 
</#if>
</#if>
</#if>
</#list>

<#list Fields as key,value>
 <#if value.isAutogenerated == false>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean"|| value.fieldType?lower_case == "date"|| value.fieldType?lower_case == "string" >
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
