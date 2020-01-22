spring.profiles.active=local

spring.application.name=[=appName]
server.port=5555
spring.main.banner-mode=off
javers.mapping-style=BEAN
spring.jackson.serialization.fail-on-empty-beans=false
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true
spring.jpa.properties.hibernate.default_schema=[=Schema]

#applciation context path
server.servlet.contextPath=/

<#if Cache!false>
# Redis setup
redis.server.port=6379
redis.server.address=localhost
</#if>

# SLF4J is a facade for logging frameworks
# Spring Boot overrides the default logging level of Logback by setting the root logger to info
logging.level.root=WARN
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate=ERROR
logging.level.org.hibernate.type.descriptor.sql=TRACE

logging.file=src/main/java/[=packageName]/logging/spring-boot-logging.txt
logging.file.max-history=2
logging.file.max-size=2000KB

# Enable SSL

# The format used for the keystore for openid testing
server.ssl.key-store-type=PKCS12
# The path to the keystore containing the certificate
server.ssl.key-store=classpath:keystore.p12
# The password used to generate the certificate
server.ssl.key-store-password=Rfhh8ek2
# The alias mapped to the certificate
server.ssl.key-alias=tomcat

<#if AuthenticationType != "none">
fastCode.auth.method=[=AuthenticationType]
<#if AuthenticationSchema??>
fastCode.usertable.name = [=AuthenticationSchema?replace("[A-Z]", "_$0", 'r')?lower_case?substring(1)]
<#else>
fastCode.usertable.name = null
</#if>
</#if>
<#if AuthenticationType == "ldap">
# LDAP Server Setup - /login
fastCode.ldap.contextsourceurl=ldap://localhost:10389/dc=nfinityllc,dc=com
fastCode.ldap.manager.dn=uid=admin,ou=system
fastCode.ldap.manager.password=secret
fastCode.ldap.usersearchbase=ou=people
fastCode.ldap.usersearchfilter=(uid={0})
fastCode.ldap.roleprefix=
fastCode.ldap.groupsearchbase=ou=groups
fastCode.ldap.groupsearchfilter=(member={0})
<#if LogonName??>
fastCode.ldap.logon.name = [=LogonName]
</#if>
#fastCode.ldap.ldiffilename=C:/Program Files/Apache Directory Studio/users.ldif
<#elseif AuthenticationType == "oidc">
spring.security.oauth2.client.registration.oidc.client-id=0oa1dpe6xa5SKvHR0357
spring.security.oauth2.client.provider.oidc.issuer-uri=https://nfinityllc-usman.okta.com/oauth2/default
#spring.security.oauth2.client.registration.oidc.client-secret=tS23X8Cipe9G7XmfZk-VesHqdXzJRiGmz4DtXP5a
</#if>

spring.main.allow-bean-definition-overriding=true

fastCode.offset.default=0
fastCode.limit.default=10
fastCode.sort.direction.default=ASC
#fastCode.sort.property.default=id