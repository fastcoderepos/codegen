<#if connectionStringInfo.database == "h2">
spring.h2.console.enabled=true
spring.h2.console.path=/h2

spring.datasource.url=[=connectionStringInfo.url];INIT=CREATE SCHEMA IF NOT EXISTS [=Schema?upper_case];DB_CLOSE_DELAY=-1
<#else>
spring.datasource.url=[=connectionStringInfo.url]?currentSchema=[=Schema]
</#if>
spring.datasource.username=[=connectionStringInfo.username]
spring.datasource.password=[=connectionStringInfo.password]
spring.datasource.driverClassName=[=connectionStringInfo.driverName]

spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.dialect=[=connectionStringInfo.dialect]
spring.jpa.hibernate.ddl-auto=update

