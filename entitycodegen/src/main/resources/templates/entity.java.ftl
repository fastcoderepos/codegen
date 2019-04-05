package ${PackageName};

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
<#if Audit!false>
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import ${AuditPackage}.AuditedEntity;
</#if>

@Entity
@Table(name = "${ClassName}", schema = "${SchemaName}")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>
public class ${ClassName}Entity <#if Audit!false>extends AuditedEntity<String></#if> implements Serializable {

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  private Long ${value.fieldName};
 <#elseif value.fieldType?lower_case == "boolean">
  private Boolean ${value.fieldName};
 <#elseif value.fieldType?lower_case == "date">
  private Date ${value.fieldName};
 <#elseif value.fieldType?lower_case == "string">
  private String ${value.fieldName};
 </#if> 
</#list>

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  <#if value.fieldName?lower_case == "id"> 
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  <#else>
  @Basic
  </#if>
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Long get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Long ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  
 <#elseif value.fieldType?lower_case == "boolean">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Boolean get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Boolean ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 <#elseif value.fieldType?lower_case == "date">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Date get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Date ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 <#elseif value.fieldType?lower_case == "string">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')}, length =<#if value.length !=0>${value.length}<#else>255</#if>)
  public String get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(String ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  
  <#else>
  <#list Relationship as relationKey, relationValue>
  <#if value.fieldType == relationValue.eName>
  <#if relationValue.relation == "ManyToOne">
  @ManyToOne
  @JoinColumn(name = "${relationValue.joinColumn}")
  public ${relationValue.eName}Entity get${relationValue.eName}() {
    return ${relationValue.fName};
  }
  public void set${relationValue.eName}(${relationValue.eName}Entity ${relationValue.fName}) {
    this.${relationValue.fName} = ${relationValue.fName};
  }
  
  private ${relationValue.eName}Entity ${relationValue.fName};
  
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if parent?keep_before("-") == relationValue.eName>
  @ManyToMany(cascade = {CascadeType.ALL})
  @JoinTable(name = "${relationValue.joinTable}", schema = "${SchemaName}",
            joinColumns = {@JoinColumn(name = "${relationValue.joinColumn}", referencedColumnName = "${relationValue.referenceColumn}")},
            inverseJoinColumns = {@JoinColumn(name = "${relationValue.inverseJoinColumn}", referencedColumnName = "${relationValue.inverseReferenceColumn}")})
  public Set<${relationValue.eName}Entity> get${relationValue.eName}s() {
    return ${relationValue.fName}s;
  }
  public void set${relationValue.eName}s(Set<${relationValue.eName}Entity> ${relationValue.fName}s) {
    this.${relationValue.fName}s = ${relationValue.fName}s;
  }

  private Set<${relationValue.eName}Entity> ${relationValue.fName}s = new HashSet<>();
  <#elseif parent?keep_after("-") == relationValue.eName>
  public void add${relationValue.eName}(${relationValue.eName}Entity input) {
    ${relationValue.fName}s.add(input);
    input.get${ClassName}s().add(this);
  }

  public void remove${relationValue.eName}(${relationValue.eName}Entity input) {
    ${relationValue.fName}s.remove(input);
    input.get${ClassName}s().remove(this);
  }
    
  @ManyToMany(mappedBy = "${ClassName?lower_case}")
  public Set<${relationValue.eName}Entity> get${relationValue.eName}s() {
    return ${relationValue.fName}s;
  }
  public void set${relationValue.eName}s(Set<${relationValue.eName}Entity> ${relationValue.fName}s) {
    this.${relationValue.fName}s = ${relationValue.fName}s;
  }

  private Set<${relationValue.eName}Entity> ${relationValue.fName}s = new HashSet<>();
  </#if>
  </#list>
  <#elseif relationValue.relation == "OneToMany">  
  @OneToMany(mappedBy = "${relationValue.mappedBy}", cascade = CascadeType.ALL, orphanRemoval = true)
  public Set<${relationValue.eName}Entity> get${relationValue.eName}s() {
    return ${relationValue.fName}s;
  }

  public void set${relationValue.eName}s(Set<${relationValue.eName}Entity> ${relationValue.fName}s) {
    this.${relationValue.fName}s = ${relationValue.fName}s;
  }

  private Set<${relationValue.eName}Entity> ${relationValue.fName}s = new HashSet<${relationValue.eName}Entity>();
  </#if>
  </#if>
  </#list>
 </#if> 
</#list>
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
      if (!(o instanceof ${ClassName}Entity)) return false;
        ${ClassName}Entity ${ClassName?lower_case} = (${ClassName}Entity) o;
        return id != null && id.equals(${ClassName?lower_case}.id);
  }
}

  
      

