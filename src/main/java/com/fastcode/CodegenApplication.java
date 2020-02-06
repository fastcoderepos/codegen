package com.fastcode;

import com.fastcode.codegen.ModulesGenerator;
import com.fastcode.entitycodegen.UserInput;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootApplication 
public class CodegenApplication implements ApplicationRunner {
	static Map<String, String> root = new HashMap<>();

	public static void main(String[] args) {
	
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);
		
		UserInput userInput = context.getBean(UserInput.class);
		ModulesGenerator generator = context.getBean(ModulesGenerator.class);
		generator.generateCode(userInput.composeInput(root)); 
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




}
