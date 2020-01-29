package [=PackageName].domain<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case];

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.irepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>
import [=PackageName].domain.irepository.I[=ClassName]Repository;
import com.querydsl.core.types.Predicate;

@Repository
public class [=ClassName]Manager implements I[=ClassName]Manager {

    @Autowired
    I[=ClassName]Repository  _[=InstanceName]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Autowired
	I[=relationValue.eName]Repository  _[=relationValue.eName?lower_case]Repository;
    </#if>
    </#list>
    
	public [=EntityClassName] Create([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	public void Delete([=EntityClassName] [=InstanceName]) {

		_[=InstanceName]Repository.delete([=InstanceName]);	
	}

	public [=EntityClassName] Update([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	public [=EntityClassName] FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {
    	Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=IdClass?uncap_first]);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName];
		} else {
		    return null;
		}

	}
	<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
	<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
	public [=EntityClassName] FindBy[=authValue.fieldName?cap_first](String [=authValue.fieldName?uncap_first]) {
		return  _[=InstanceName]Repository.findBy[=authValue.fieldName?cap_first]([=authValue.fieldName?uncap_first]);
	}
	</#if>
    </#list>
    </#if>
    </#if>

	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne"|| relationValue.relation == "OneToOne">
  
   //[=relationValue.eName]
	public [=relationValue.eName]Entity Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {
		
		Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=IdClass?uncap_first]);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName].get[=relationValue.eName]();
		} else {
		    return null;
		}
	}
   </#if>
  </#list>
}
