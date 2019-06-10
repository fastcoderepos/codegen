package com.nfinity.codegen;

import com.nfinity.entitycodegen.BaseAppGen;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.GetUserInput;
import com.nfinity.entitycodegen.UserInput;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class CodegenApplication implements ApplicationRunner {
	static Map<String, String> root = new HashMap<>();

	public static UserInput composeInput(FastCodeProperties configProperties) {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);
		System.out.println(" v " + root.get("c") + "\n ss " + root.get("s"));
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// /Users/getachew/fc/exer/root
		input.setConnectionStr(root.get("c") != null ? root.get("c")
				: (configProperties.getConnectionStr() != null ? configProperties.getConnectionStr()
						: GetUserInput.getInput(scanner, "DB Connection String")));
		input.setSchemaName(root.get("s") == null ? GetUserInput.getInput(scanner, "Db schema") : root.get("s"));
		input.setDestinationPath(
				root.get("d") == null ? GetUserInput.getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? GetUserInput.getInput(scanner, "application name") : root.get("a"));
		input.setGenerationType(
				root.get("t") == null ? GetUserInput.getInput(scanner, "generation type") : root.get("t"));
		input.setAudit(root.get("audit") == null
				? (GetUserInput.getInput(scanner, "auditing").toLowerCase().equals("true") ? true : false)
				: (root.get("audit").toLowerCase().equals("true") ? true : false));
		input.setHistory(root.get("h") == null
				? (GetUserInput.getInput(scanner, "history").toLowerCase().equals("true") ? true : false)
				: (root.get("h").toLowerCase().equals("true") ? true : false));

		return input;
	}

	public static void main(String[] args) throws ClassNotFoundException {
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);
		FastCodeProperties configProperties = context.getBean(FastCodeProperties.class);

		UserInput input = composeInput(configProperties);

		// String sourcePackageName = root.get("p");
		// sourcePackageName = (sourcePackageName == null) ? root.get("e") :
		// sourcePackageName;
		String groupArtifactId = input.getGroupArtifactId().isEmpty() ? "com.group.demo" : input.getGroupArtifactId();
		String artifactId = groupArtifactId.substring(groupArtifactId.lastIndexOf(".") + 1);
		String groupId = groupArtifactId.substring(0, groupArtifactId.lastIndexOf("."));

		// c=jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// String connectionString = root.get("c");

		BaseAppGen.CreateBaseApplication(input.getDestinationPath(), artifactId, groupId, "web,data-jpa,data-rest",
				true, "-n=" + artifactId + "  -j=1.8 ");
		Map<String, EntityDetails> details = EntityGenerator.generateEntities(input.getConnectionStr(),
				input.getSchemaName(), null, groupArtifactId, input.getDestinationPath() + "/" + artifactId,
				input.getAudit());
		BaseAppGen.CompileApplication(input.getDestinationPath() + "/" + artifactId);

		FronendBaseTemplateGenerator.generate(input.getDestinationPath(), artifactId + "Client");

		CodeGenerator.GenerateAll(artifactId, artifactId + "Client", groupArtifactId, groupArtifactId, input.getAudit(),
				input.getHistory(),
				input.getDestinationPath() + "/" + artifactId + "/target/classes/"
						+ (groupArtifactId + ".model").replace(".", "/"),
				input.getDestinationPath(), input.getGenerationType(), details, input.getConnectionStr(),
				input.getSchemaName());
		if (configProperties.getUseGit() != null
				? (configProperties.getUseGit().equalsIgnoreCase("true") ? true : false)
				: false) {
			GitRepositoryManager.addToGitRepository(input.getDestinationPath());
		}
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		System.out.println("# NonOptionArgs: " + args.getNonOptionArgs().size());

		System.out.println("NonOptionArgs:");
		args.getNonOptionArgs().forEach(System.out::println);

		System.out.println("# OptionArgs: " + args.getOptionNames().size());
		System.out.println("OptionArgs:");

		args.getOptionNames().forEach(optionName -> {
			root.put(optionName, args.getOptionValues(optionName).get(0));
			System.out.println(optionName + "=" + args.getOptionValues(optionName));
		});
	}

	private static class FastCodeProperties {

		@Value("${fastCode.connectionStr:#{null}}")
		private Optional<String> connectionStr;
		@Value("${fastCode.username:#{null}}")
		private Optional<String> username;
		@Value("${fastCode.password:#{null}}")
		private Optional<String> password;

		public String getConnectionStr() {

			return connectionStr.isPresent()
					? (connectionStr.get() + "username=" + username.get() + ";password=" + password.get())
					: null;
		}

		@Value("${fastCode.bootVersion}")
		private String bootVersion;

		public String getBootVersion() {
			return bootVersion;
		}

		@Value("${fastCode.build}")
		private String build;

		public String getBuild() {
			return build;
		}

		@Value("${fastCode.dependencies}")
		private String dependencies;

		public String getDependencies() {
			return dependencies;
		}

		@Value("${fastCode.force}")
		private boolean force;

		public boolean getForce() {
			return force;
		}

		@Value("${fastCode.javaVersion}")
		private String javaVersion;

		public String getJavaVersion() {
			return javaVersion;
		}

		@Value("${fastCode.packaging}")
		private String packaging;

		public String getPackaging() {
			return packaging;
		}

		@Value("${fastCode.version}")
		private String version;

		public String getVersion() {
			return version;
		}

		@Value("${fastCode.useGit}")
		private Optional<String> useGit;

		public String getUseGit() {
			return useGit.isPresent() ? useGit.get() : null;
		}
	}

	@Bean
	FastCodeProperties myBean() {
		return new FastCodeProperties();
	}

}
