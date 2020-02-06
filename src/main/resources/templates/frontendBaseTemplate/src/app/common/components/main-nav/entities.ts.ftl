export var Entities: string[] = [
	<#list EntityList as entity>
	<#if !UserInput?? || AuthenticationTable?lower_case != entity?lower_case>
	"[=entity?lower_case]",
	</#if>
	</#list>
]

export var AuthEntities: string[] = [
	<#list AuthEntityList as entity>
	"[=entity?lower_case]",
	</#list>
]