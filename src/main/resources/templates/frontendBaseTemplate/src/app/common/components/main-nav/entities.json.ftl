[
<#list EntityNames as module,entity>
<#if entity != AuthenticationTable>
	[=entity?lower_case],
</#if>
</#list>
]