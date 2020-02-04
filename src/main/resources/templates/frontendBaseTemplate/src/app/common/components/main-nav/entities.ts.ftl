export var Entities: string[] = [
    <#list EntityList as entity>
    "[=entity?lower_case]",
    </#list>
]

export var AuthEntities: string[] = [
    <#list AuthEntityList as entity>
    "[=entity?lower_case]",
    </#list>
]