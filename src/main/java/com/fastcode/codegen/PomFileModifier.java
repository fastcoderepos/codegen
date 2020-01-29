package com.fastcode.codegen;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import com.fastcode.logging.LoggingHelper;

@Component
public class PomFileModifier {
	
	@Autowired
	private LoggingHelper logHelper;

	public void updatePomFile(String path,String authenticationType,Boolean cache) {
		List<Dependency> dependencies = new ArrayList<Dependency>();

		Dependency mapstruct = new Dependency("org.mapstruct", "mapstruct", "1.2.0.Final");
		Dependency querydsljpa = new Dependency("com.querydsl", "querydsl-jpa", "4.2.1");
		Dependency querydslapt= new Dependency("com.querydsl", "querydsl-apt", "4.2.1");
		Dependency apache_commons = new Dependency("org.apache.commons", "commons-lang3", "3.8.1");
		Dependency postgres = new Dependency("org.postgresql","postgresql","42.2.5");
		Dependency h2 = new Dependency("com.h2database","h2","");

		Dependency springFoxSwagger = new Dependency("io.springfox","springfox-swagger2","2.7.0");
		Dependency springFoxSwaggerUI = new Dependency("io.springfox","springfox-swagger-ui","2.7.0");
		Dependency springFoxDataRest = new Dependency("io.springfox","springfox-data-rest","2.8.0");
	    Dependency httpComponents = new Dependency("org.apache.httpcomponents","httpclient","4.5");
 
	    Dependency gson = new Dependency("com.google.code.gson","gson","2.8.5");
	    
	    if(cache)
	    {
	    	Dependency springDataRedis = new Dependency("org.springframework.data","spring-data-redis","2.1.9.RELEASE");
			Dependency redisClient = new Dependency("redis.clients","jedis","2.9.0","jar","compile");
			dependencies.add(springDataRedis);
			dependencies.add(redisClient);
	    }
	    
		if(authenticationType !="none")
		{
			Dependency json_web_token =new Dependency("io.jsonwebtoken","jjwt","0.9.0");
			dependencies.add(json_web_token);
			Dependency ldap_security = new Dependency("org.springframework.security","spring-security-ldap","5.1.1.RELEASE");
			dependencies.add(ldap_security);
			Dependency nimbus= new Dependency("com.nimbusds","nimbus-jose-jwt","7.7");
			dependencies.add(nimbus);
		}

		dependencies.add(mapstruct);
		dependencies.add(querydsljpa);
		dependencies.add(querydslapt);
		dependencies.add(apache_commons);
		dependencies.add(postgres);
		dependencies.add(h2);
		dependencies.add(springFoxSwagger);
		dependencies.add(springFoxSwaggerUI);
		dependencies.add(springFoxDataRest);
		dependencies.add(httpComponents);
		dependencies.add(gson);
		
		addDependenciesAndPluginsToPom(path,dependencies);
	}
	
	public void addDependenciesAndPluginsToPom(String path, List<Dependency> dependencies) {

		try {
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(path);

			// Get the staff element by tag name directly
			Node dependenciesNode = doc.getElementsByTagName("dependencies").item(0);
			for(Dependency dependency:dependencies){

				Element dependencyNode = doc.createElement("dependency");
				String groupId = dependency.getGroupId();
				String artifactId = dependency.getArtifactId();
				String version = dependency.getVersion();
				String scope = dependency.getScope();
				String type = dependency.getType();

				if(!groupId.isEmpty()){
					Element elem = doc.createElement("groupId");
					elem.appendChild(doc.createTextNode(groupId));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

				if(!artifactId.isEmpty()){
					Element elem = doc.createElement("artifactId");
					elem.appendChild(doc.createTextNode(artifactId));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

				if(!version.isEmpty()){
					Element elem = doc.createElement("version");
					elem.appendChild(doc.createTextNode(version));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}
				
				if(!type.isEmpty()){
					Element elem = doc.createElement("type");
					elem.appendChild(doc.createTextNode(type));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}
				
				if(!scope.isEmpty()){
					Element elem = doc.createElement("scope");
					elem.appendChild(doc.createTextNode(scope));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

			} 

			Node pluginsNode = doc.getElementsByTagName("plugins").item(0);
			List<Element> pluginList = getPlugins(doc);
			for(Element plugin:pluginList) {
				pluginsNode.appendChild(plugin);
			}
			
			// write the content into xml file
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new File(path));
			transformer.transform(source, result);

			logHelper.getLogger().info("Done");

		} catch (ParserConfigurationException pce) {
			logHelper.getLogger().error("ParserConfigurationException : ", pce.getMessage());
		} catch (TransformerException tfe) {
			logHelper.getLogger().error("TransformerException : ", tfe.getMessage());
		} catch (IOException ioe) {
			logHelper.getLogger().error("IOException : ", ioe.getMessage());
		} catch (SAXException sae) {
			logHelper.getLogger().error("SAXException : ", sae.getMessage());
		}
	}

	public List<Element> getPlugins(Document doc){
		List<Element> elemList = new ArrayList<Element>();

		Element mysema = doc.createElement("plugin");

		Element elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("com.mysema.maven"));
		mysema.appendChild(elem);

		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("apt-maven-plugin"));
		mysema.appendChild(elem);

		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("1.1.3"));
		mysema.appendChild(elem);

		elem = doc.createElement("executions");

		Element execution = doc.createElement("execution");
		Element goals = doc.createElement("goals");
		Element goal = doc.createElement("goal");

		goal.appendChild(doc.createTextNode("process"));
		goals.appendChild(goal);
		execution.appendChild(goals);

		Element configuration = doc.createElement("configuration");
		Element outputDirectory = doc.createElement("outputDirectory");
		outputDirectory.appendChild(doc.createTextNode("target/generated-sources"));
		Element processor = doc.createElement("processor");
		processor.appendChild(doc.createTextNode("com.querydsl.apt.jpa.JPAAnnotationProcessor"));

		configuration.appendChild(outputDirectory);
		configuration.appendChild(processor);
		execution.appendChild(configuration);

		elem.appendChild(execution);		
		mysema.appendChild(elem);

		elemList.add(mysema);
		elemList.add(getMapStructPlugIn(doc));
		return elemList;
	}

	public Element getMapStructPlugIn(Document doc)
	{
		Element mapStruct = doc.createElement("plugin");

		Element elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.apache.maven.plugins"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("maven-compiler-plugin"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("3.5.1"));
		mapStruct.appendChild(elem);

		Element configuration = doc.createElement("configuration");
		Element useIncrementalCompilation = doc.createElement("useIncrementalCompilation");
		useIncrementalCompilation.appendChild(doc.createTextNode("false"));
		Element source = doc.createElement("source");
		source.appendChild(doc.createTextNode("1.8"));
		Element target = doc.createElement("target");
		target.appendChild(doc.createTextNode("1.8"));

		Element annotationProcessorPaths = doc.createElement("annotationProcessorPaths");
		Element path = doc.createElement("path");
		elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.mapstruct"));
		path.appendChild(elem);
		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("mapstruct-processor"));
		path.appendChild(elem);
		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("1.2.0.Final"));
		path.appendChild(elem);

		annotationProcessorPaths.appendChild(path);
		configuration.appendChild(useIncrementalCompilation);
		configuration.appendChild(source);
		configuration.appendChild(target);
		configuration.appendChild(annotationProcessorPaths);

		mapStruct.appendChild(configuration);
        
		return mapStruct;
	}

}
