package com.fastcode.entitycodegen;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;
import org.apache.openjpa.jdbc.sql.DBDictionary;
import org.apache.openjpa.lib.util.Options;
import org.postgresql.util.PSQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.apache.openjpa.jdbc.sql.H2Dictionary;

import org.apache.openjpa.jdbc.sql.PostgresDictionary;

import com.fastcode.logging.LoggingHelper;


@Component
public class ReverseMapping {

	@Autowired
	LoggingHelper logHelper;
	
	public void run(String packageName, String directory, String schemaName, Map<String,String> connectionProps) throws IOException, SQLException 
	{
		//packageName : "com.nfinity.fastcode.model"
		//directory : "src/main/java"
		//tableName : "dbo.users,dbo.roles"


		
			Options opts = new Options();
		
			try {
				ReverseMappingTool.run(configureJdbc(connectionProps), configureCommandLineArguments(packageName,directory,schemaName,opts), opts);
				logHelper.getLogger().info(" Generating resources ... ");
			
			}catch (RuntimeException e) {
				// TODO Auto-generated catch block
				System.out.println("EROR" + e.getMessage());
				e.getStackTrace();
				throw new SQLException( "Unable to connect to provided database");
			}
			catch (SQLException e) {
				// TODO Auto-generated catch block
				System.out.println("ERORR" + e.getMessage());
				e.getStackTrace();
				throw new SQLException( "Unable to connect to provided database");

			}catch (IOException e) {
				// TODO Auto-generated catch block
				System.out.println("ERORRR" + e.getMessage());
				e.getStackTrace();
				throw new IOException( "Unable to connect to provided database");

			}
			
			
		
	}
	
	public String[] configureCommandLineArguments(String packageName, String directory, String schemaName,Options opts)
	{ 
		String schemaKey= schemaName.contains(",")?"-s":"-schema";
		System.out.println(" schema name " + schemaName);
		String[] optionsArray = {"-pkg", packageName, "-d", directory, schemaKey, schemaName, "-ann","t" };
	    final String[] arguments = opts.setFromCmdLine(optionsArray);
	    
	    return arguments;
	}
	
	public JDBCConfiguration configureJdbc(Map<String,String> connectionProps)
	{
		JDBCConfiguration conf = new JDBCConfigurationImpl();
		System.out.println(" url " + connectionProps.get("url"));
		System.out.println(" userName " + connectionProps.get("username"));
		System.out.println(" password " + connectionProps.get("password"));
		System.out.println(" driver Name " + connectionProps.get("driverName"));
		
		conf.setConnectionURL(connectionProps.get("url"));
		conf.setConnectionUserName(connectionProps.get("username"));
		conf.setConnectionPassword(connectionProps.get("password"));
		conf.setConnectionDriverName(connectionProps.get("driverName"));

		DBDictionary dc = conf.getDBDictionaryInstance();
		dc.supportsNullTableForGetPrimaryKeys = false;
		dc.supportsNullTableForGetIndexInfo = false;
		conf.setDBDictionary(dc);
		
		return conf;
	}

}
