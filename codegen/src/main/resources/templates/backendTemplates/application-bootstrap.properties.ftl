spring.datasource.url=[=connectionStringInfo.url]?currentSchema=[=Schema]
spring.datasource.username=[=connectionStringInfo.username]
spring.datasource.password=[=connectionStringInfo.password]
spring.datasource.driverClassName=org.postgresql.Driver
spring.quartz.job-store-type=jdbc
spring.quartz.jdbc.initialize-schema=always

spring.jpa.hibernate.ddl-auto=create
spring.jpa.show-sql=true
spring.jpa.generate-ddl=true