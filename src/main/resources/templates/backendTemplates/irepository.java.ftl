package [=PackageName].domain.irepository;

<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "OneToMany">
import [=PackageName].domain.model.[=relationValue.eName]Entity; 
</#if>
</#list>
import java.util.List;
import [=PackageName].domain.model.[=EntityClassName];

@RepositoryRestResource(collectionResourceRel = "[=ApiPath]", path = "[=ApiPath]")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], <#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list></#if>>,QuerydslPredicateExecutor<[=EntityClassName]> {

<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
    @Query("select u from [=EntityClassName] u where u.[=authValue.fieldName?uncap_first] = ?1")
    [=EntityClassName] findBy[=authValue.fieldName?cap_first](String value);  
    </#if>
    </#list> 
</#if>
</#if>
}
