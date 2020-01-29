package [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case];

import java.util.List;
import javax.validation.constraints.Positive;
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto.*;

@Service
public interface I[=ClassName]AppService {

	Create[=ClassName]Output Create(Create[=ClassName]Input [=ClassName?lower_case]);

    void Delete(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> id</#if>);

    Update[=ClassName]Output Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> id</#if>, Update[=ClassName]Input input);

    Find[=ClassName]ByIdOutput FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> id</#if>);

    List<Find[=ClassName]ByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	<#if CompositeKeyClasses?seq_contains(ClassName)>
	public [=IdClass] parse[=ClassName]Key(String keysString);
	</#if>
    <#list Relationship as relationKey, relationValue>
    <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
    
    //[=relationValue.eName]
    Get[=relationValue.eName]Output Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=InstanceName]id</#if>);
   </#if>
   </#list>
}
