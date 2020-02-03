package com.fastcode.codegen;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.entitycodegen.AuthenticationConstants;
import com.fastcode.entitycodegen.BaseAppGen;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.EntityGenerator;
import com.fastcode.entitycodegen.UserInput;
import com.fastcode.logging.LoggingHelper;

@Component
public class ModulesGenerator {
	
	@Autowired
	private CommonModuleTemplateGenerator commonModule;
	
	@Autowired
	private AuthenticationClassesTemplateGenerator authClasses;
	
	@Autowired
	private CodeGenerator codeGenerator;
	
	@Autowired
    private EntityGenerator entityGenerator;
	
	@Autowired
	private BaseAppGen baseAppGen;
	
	@Autowired
	private FrontendBaseTemplateGenerator frontendGenerator;
	
	@Autowired
	private GitRepositoryManager gitRepositoryManager;
	
	@Autowired
	private PomFileModifier pomFileModifier;
	
	@Autowired
	private LoggingHelper logHelper;
	
	@Autowired
	private CodegenDependenciesIdentifier dependenciesIdentifier;
	
	public void generateCode(UserInput input) { 
	
		File dir = new File(input.getDestinationPath());
		if(!dir.exists()) {
			dir.mkdirs();
		};

		dependenciesIdentifier.setDestinationPath(input.getDestinationPath());
		
		if(!dependenciesIdentifier.checkDependencies())
		{
			System.exit(1);
		}

		gitRepositoryManager.setDestinationPath(input.getDestinationPath());
		String sourceBranch = "";
		if(gitRepositoryManager.isGitInstalled()) {
			if(!gitRepositoryManager.isGitInitialized()) {
				gitRepositoryManager.initializeGit();
				logHelper.getLogger().info("Git repository initialized.");
			}
			//Clean up old files if needed
		}
		else {
			logHelper.getLogger().error("Git repository could not be initialized, as Git is not installed on your system.");
			System.exit(1);
		}
		
		if(input.getUpgrade()) {
			if(gitRepositoryManager.hasUncommittedChanges()) {
				logHelper.getLogger().info("\nGit has uncommitted changes. ");
				System.exit(1);
			}
			else {
				sourceBranch = gitRepositoryManager.getCurrentBranch();
				if(!gitRepositoryManager.createUpgradeBranch()) {
					logHelper.getLogger().error("Unable to create upgrade branch.");
					System.exit(1);
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
		
		if(!input.getAuthenticationMap().get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("none"))
		{
			dependencies = dependencies.concat(",security");
		}

		baseAppGen.CreateBaseApplication(input.getDestinationPath(), artifactId, groupId, dependencies,
				true, "-n=" + artifactId + "  -j=1.8 ");
		try { 
		Map<String, EntityDetails> details = entityGenerator.generateEntities(input.getConnectionStr(),
				input.getSchemaName(), null, groupArtifactId, input.getDestinationPath() + "/" + artifactId,input.getAuthenticationMap());


		pomFileModifier.updatePomFile(input.getDestinationPath() + "/" + artifactId + "/pom.xml",input.getAuthenticationMap().get(AuthenticationConstants.AUTHENTICATION_TYPE),input.getCache());
		commonModule.generateCommonModuleClasses(input.getDestinationPath()+ "/" + artifactId, groupArtifactId);
		baseAppGen.CompileApplication(input.getDestinationPath() + "/" + artifactId);
 
		frontendGenerator.generate(input.getDestinationPath(), artifactId, input.getAuthenticationMap(), details);

		if(!input.getAuthenticationMap().get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("none"))
		{
			authClasses.generateAutheticationClasses(input.getDestinationPath(), groupArtifactId,input.getCache(),input.getSchemaName(),input.getAuthenticationMap(),details);
		}

		codeGenerator.generateAll(artifactId, artifactId + "Client", groupArtifactId, input.getCache(),
						input.getDestinationPath(), details, input.getConnectionStr(),
						input.getSchemaName(),input.getAuthenticationMap());

		gitRepositoryManager.addToGitRepository(input.getUpgrade(), sourceBranch);

		logHelper.getLogger().info("\n Code generation Completed ...");
		System.exit(0);
		}
		
		catch (IllegalStateException | IOException | SQLException e) {
			logHelper.getLogger().error(" Exception Occured " , e.getMessage());
			logHelper.getLogger().error("\n Code generation terminated ...");
			System.exit(1);
		} 
		
		

	}

}
