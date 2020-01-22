package [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case];

import org.mapstruct.Mapper;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation =="OneToOne">
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
<#break>
</#if>
</#list>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto.*;
import [=PackageName].domain.model.[=ClassName]Entity;

@Mapper(componentModel = "spring")
public interface [=ClassName]Mapper {

   [=ClassName]Entity Create[=ClassName]InputTo[=ClassName]Entity(Create[=ClassName]Input [=ClassName?lower_case]Dto);
   
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if>
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??>
   <#if !Fields[joinDetails.joinColumn]??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#if>
   </#list>
   <#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=DescriptiveField[relationValue.eName].description?uncap_first]"),                    
   </#if>
   </#if>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   }) 
   <#break> 
   </#if> 
   </#if>
   </#if> 
   </#list> 
   Create[=ClassName]Output [=ClassName]EntityToCreate[=ClassName]Output([=ClassName]Entity entity);

   [=ClassName]Entity Update[=ClassName]InputTo[=ClassName]Entity(Update[=ClassName]Input [=ClassName?lower_case]Dto);

   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if>
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??>
   <#if !Fields[joinDetails.joinColumn]??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#if>
   </#list>
   <#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=DescriptiveField[relationValue.eName].description?uncap_first]"),                    
   </#if>
   </#if>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#if>
   </#list> 
   Update[=ClassName]Output [=ClassName]EntityToUpdate[=ClassName]Output([=ClassName]Entity entity);

   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if>
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??>
   <#if !Fields[joinDetails.joinColumn]??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#if>
   </#list>
   <#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
   @Mapping(source = "[=relationValue.eName?uncap_first].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=DescriptiveField[relationValue.eName].description?uncap_first]"),                    
   </#if>
   </#if>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if relationValue.isParent == false>
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content>  
   }) 
   <#break> 
   </#if> 
   </#if>
   </#if> 
   </#list> 
   Find[=ClassName]ByIdOutput [=ClassName]EntityToFind[=ClassName]ByIdOutput([=ClassName]Entity entity);

<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
   Find[=ClassName]WithAllFieldsByIdOutput [=ClassName]EntityToFind[=ClassName]WithAllFieldsByIdOutput([=ClassName]Entity entity);

<#if AuthenticationFields??>
<#list AuthenticationFields as authKey,authValue>
<#if authKey== "UserName"> 
   Find[=ClassName]By[=authValue.fieldName?cap_first]Output [=ClassName]EntityToFind[=ClassName]By[=authValue.fieldName?cap_first]Output([=ClassName]Entity entity);
</#if>
</#list>
</#if>
</#if>

   <#list Relationship as relationKey, relationValue>
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   @Mappings({
   <#list relationValue.fDetails as fValue>
   <#list Fields as key,value> 
   <#if fValue.fieldName == value.fieldName>
   <#if fValue.fieldType?lower_case == "long" || fValue.fieldType?lower_case == "integer" || fValue.fieldType?lower_case == "short" || fValue.fieldType?lower_case == "double" || fValue.fieldType?lower_case == "boolean" || fValue.fieldType?lower_case == "date" || fValue.fieldType?lower_case == "string">
   @Mapping(source = "[=relationValue.eName?uncap_first].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
   </#if>
   </#if>
   </#list>
   </#list> 
   <#list Fields as fkey,fvalue>
   <#if fvalue.isPrimaryKey!false>
   <#if fvalue.fieldType?lower_case == "long" || fvalue.fieldType?lower_case == "integer" || fvalue.fieldType?lower_case == "short" || fvalue.fieldType?lower_case == "double" || fvalue.fieldType?lower_case == "boolean" || fvalue.fieldType?lower_case == "date" || fvalue.fieldType?lower_case == "string">
   @Mapping(source = "[=ClassName?uncap_first].[=fvalue.fieldName]", target = "[=ClassName?uncap_first][=fvalue.fieldName?cap_first]"),
   </#if>
   </#if>
   </#list>
   })
   Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?uncap_first], [=EntityClassName] [=InstanceName]);

   </#if>
   </#list>
}
