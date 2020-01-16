package com.fastcode.entitycodegen;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;
import org.apache.openjpa.lib.util.Options;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;


@Component
public class ReverseMapping {

	@Autowired
	LoggingHelper logHelper;
	
	public void run(String packageName, String directory, String schemaName, Map<String,String> connectionProps)
	{
		//packageName : "com.nfinity.fastcode.model"
		//directory : "src/main/java"
		//tableName : "dbo.users,dbo.roles"
		
		//String schemaKey= schemaName.contains(",")?"-s":"-schema";
		//String[] optionsArray = {"-pkg", packageName, "-d", directory, schemaKey, schemaName, "-ann","t" };

		try {
			Options opts = new Options();
		//	final String[] arguments = opts.setFromCmdLine(optionsArray);
			
			ReverseMappingTool.run(configureJdbc(connectionProps), configureCommandLineArguments(packageName,directory,schemaName,opts), opts);

			logHelper.getLogger().info(" Generating resources ... ");
			
		} catch (IOException e) {
			logHelper.getLogger().error("Error Occured : ", e.getMessage());
		} catch (SQLException e) {
			logHelper.getLogger().error("Error Occured : ", e.getMessage());
		}
	}
	
	public String[] configureCommandLineArguments(String packageName, String directory, String schemaName,Options opts)
	{
		String schemaKey= schemaName.contains(",")?"-s":"-schema";
		String[] optionsArray = {"-pkg", packageName, "-d", directory, schemaKey, schemaName, "-ann","t" };
	    final String[] arguments = opts.setFromCmdLine(optionsArray);
	    
	    return arguments;
	}
	
	public JDBCConfiguration configureJdbc(Map<String,String> connectionProps)
	{
		JDBCConfiguration conf = new JDBCConfigurationImpl();
		
		conf.setConnectionURL(connectionProps.get("url"));
		conf.setConnectionUserName(connectionProps.get("username"));
		conf.setConnectionPassword(connectionProps.get("password"));
		conf.setConnectionDriverName("org.postgresql.Driver");
		
		return conf;
	}

}
