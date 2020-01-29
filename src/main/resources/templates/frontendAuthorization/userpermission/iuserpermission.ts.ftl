export interface I[=AuthenticationTable]permission {  

  revoked?: boolean,
	permissionId: number;
	permissionDescriptiveField?: string;
	<#if !UserInput??>
	[=AuthenticationTable?uncap_first]Id: number;
	[=AuthenticationTable?uncap_first]DescriptiveField?: string;
	<#elseif UserInput??>
	<#if PrimaryKeys??>
	<#list PrimaryKeys as key,value>
	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double">
	[=AuthenticationTable?uncap_first + key?cap_first] : number;
	<#elseif value?lower_case == "date" || value?lower_case == "string">
	[=AuthenticationTable?uncap_first + key?cap_first] : string;
	<#elseif value?lower_case == "boolean">
	[=AuthenticationTable?uncap_first + key?cap_first] : boolean;
	</#if> 
	</#list>
	</#if>
	<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
	[=DescriptiveField[AuthenticationTable].description?uncap_first]: string;
  <#else>
	<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
	<#if !PrimaryKeys[authValue.fieldName]??>
	[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]: string;
	</#if>
  </#if>
  </#list>
  </#if>
	</#if>
	</#if>
  }
