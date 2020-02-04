package [=PackageName];

<#if Cache !false>
import java.util.ArrayList;
import java.util.List;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.concurrent.ConcurrentMapCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.cache.transaction.TransactionAwareCacheManagerProxy;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
</#if>
<#if AuthenticationType != "none">
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;
</#if>
<#if AuthenticationType == "database">
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
</#if>
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
<#if AuthenticationType != "none">
@EnableTransactionManagement
@EnableJpaRepositories
</#if>
public class BeanConfig {
    
    @Autowired 
    private Environment environment; 

<#if AuthenticationType == "database">
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
</#if>

<#if Cache !false>
     @Bean
     JedisConnectionFactory jedisConnectionFactory() {
         RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration(environment.getProperty("redis.server.address"), Integer.parseInt(environment.getProperty("redis.server.port")));
         return new JedisConnectionFactory(redisStandaloneConfiguration);
     }
 
     @Bean
     public RedisTemplate<String, Object> redisTemplate() {
         RedisTemplate<String, Object> template = new RedisTemplate<>();
         JedisConnectionFactory jc = jedisConnectionFactory();
         jc.getPoolConfig().setMaxIdle(30);
         jc.getPoolConfig().setMinIdle(10);
         template.setConnectionFactory(jc);
	         return template;
     }

     @Bean
     public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();

        List<Cache> caches = new ArrayList<>();
        <#if (AuthenticationType =="database" || UserOnly) && !UserInput?? >
        caches.add(new ConcurrentMapCache("[=AuthenticationTable]"));
        </#if>
        <#if AuthenticationType == "database" || !UserOnly>
        caches.add(new ConcurrentMapCache("Role"));
        caches.add(new ConcurrentMapCache("Permission"));
        caches.add(new ConcurrentMapCache("Rolepermission"));
        </#if>
        <#if AuthenticationType == "database" || UserOnly>
        caches.add(new ConcurrentMapCache("[=AuthenticationTable]role"));
        caches.add(new ConcurrentMapCache("[=AuthenticationTable]permission"));
        </#if>
        <#list EntitiesMap as entityKey, entityMap>
		caches.add(new ConcurrentMapCache("[=entityKey?cap_first]"));
		</#list>

        cacheManager.setCaches(caches );

        // manually call initialize the caches as our SimpleCacheManager is not declared as a bean
        cacheManager.initializeCaches();

        return new TransactionAwareCacheManagerProxy( cacheManager );
    }
</#if>    
  
    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build()
                .pathMapping("/");
    }
    
}
