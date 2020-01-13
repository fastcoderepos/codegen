package com.nfinity.codegen;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nfinity.entitycodegen.BaseAppGen;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.UserInput;

@Component
public class ModulesGenerator {
	
	@Autowired
	CommonModuleTemplateGenerator commonModule;
	
	@Autowired
	AuthenticationClassesTemplateGenerator authClasses;
	
	@Autowired
	CodeGenerator codeGenerator;
	
	@Autowired
    EntityGenerator entityGenerator;
	
	@Autowired
	BaseAppGen baseAppGen;
	
	@Autowired
	FrontendBaseTemplateGenerator frontendGenerator;
	
	@Autowired
	GitRepositoryManager gitRepositoryManager;
	
	@Autowired
	PomFileModifier pomFileModifier;
	
	public void generateCode(UserInput input) throws IOException { 
	
		File dir = new File(input.getDestinationPath());
		if(!dir.exists()) {
			dir.mkdirs();
		};

		gitRepositoryManager.setDestinationPath(input.getDestinationPath());
		String sourceBranch = "";
		if(gitRepositoryManager.isGitInstalled()) {
			if(!gitRepositoryManager.isGitInitialized()) {
				gitRepositoryManager.initializeGit();
				System.out.print("Git repository initialized.");
			}
			//Clean up old files if needed
		}
		else {
			System.out.print("Git repository could not be initialized, as Git is not installed on your system.");
			return;
		}
		
		if(input.getUpgrade()) {
			if(gitRepositoryManager.hasUncommittedChanges()) {
				System.out.print("\nGit has uncommitted changes. ");
				return;
			}
			else {
				sourceBranch = gitRepositoryManager.getCurrentBranch();
				if(!gitRepositoryManager.createUpgradeBranch()) {
					System.out.print("Unable to create upgrade branch.");
					return;
				}
			}
		}
		else {
			gitRepositoryManager.CopyGitFiles();

		}

		String groupArtifactId = input.getGroupArtifactId().isEmpty() ? "com.group.demo" : input.getGroupArtifactId();
		groupArtifactId = groupArtifactId.toLowerCase();
		String artifactId = groupArtifactId.substring(groupArtifactId.lastIndexOf(".") + 1);
		String groupId = groupArtifactId.substring(0, groupArtifactId.lastIndexOf("."));
    
		// c=jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// String connectionString = root.get("c");
		String dependencies ="web,data-jpa,data-rest";
		if(input.getCache())
		{
			dependencies = dependencies.concat(",cache");
		}
		if(input.getAuthenticationType()!="none")
		{
			dependencies = dependencies.concat(",security");
		}

		baseAppGen.CreateBaseApplication(input.getDestinationPath(), artifactId, groupId, dependencies,
				true, "-n=" + artifactId + "  -j=1.8 ");
		
		Map<String, EntityDetails> details = entityGenerator.generateEntities(input.getConnectionStr(),
				input.getSchemaName(), null, groupArtifactId, input.getDestinationPath() + "/" + artifactId,input.getAuthenticationSchema(),input.getAuthenticationType());

		pomFileModifier.updatePomFile(input.getDestinationPath() + "/" + artifactId + "/pom.xml",input.getAuthenticationType(),input.getCache());
		commonModule.generateCommonModuleClasses(input.getDestinationPath()+ "/" + artifactId, groupArtifactId);
		baseAppGen.CompileApplication(input.getDestinationPath() + "/" + artifactId);

		frontendGenerator.generate(input.getDestinationPath(), artifactId, input.getAuthenticationType(), input.getAuthenticationSchema());

		if(!input.getAuthenticationType().equals("none"))
		{
			authClasses.generateAutheticationClasses(input.getDestinationPath(), groupArtifactId,input.getCache(),input.getAuthenticationType(),input.getSchemaName(),input.getAuthenticationSchema(),details);
		}

		codeGenerator.generateAll(artifactId, artifactId + "Client", groupArtifactId, input.getCache(),
						input.getDestinationPath(), input.getGenerationType(), details, input.getConnectionStr(),
						input.getSchemaName(),input.getAuthenticationType(),input.getAuthenticationSchema());


		gitRepositoryManager.addToGitRepository(input.getUpgrade(), sourceBranch);

		System.out.println("\n Code generation Completed ...");
		System.exit(1);

	}

}
