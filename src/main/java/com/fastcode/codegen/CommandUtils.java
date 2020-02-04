package com.fastcode.codegen;

import java.io.*;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;

@Component
public class CommandUtils {
    private static ProcessBuilder builder = null;
    
    @Autowired
	private LoggingHelper logHelper;

    public String runProcess(String[] command, String path, Boolean writeOutput) {
        try {
            if (builder == null)
                builder = new ProcessBuilder();

            File cmdDirectory = new File(path);

            Process process; 
            builder.command(command);
            builder.directory(cmdDirectory);

            process = builder.start();
            StringBuilder outputValue = new StringBuilder();

            BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = br.readLine()) != null) {
                if (writeOutput) {
                    System.out.println(line);
                }
                outputValue.append(line);
                outputValue.append("\n");
            }
            int exitCode = 0;
            exitCode = process.waitFor();
            assert exitCode == 0;
            return outputValue.toString().trim();
        } catch (Exception e) {
        	logHelper.getLogger().error("Error Occured : ", e.getMessage());
            throw new InternalError(e);
        }
    } 

    public String runProcess(String command, String path) {
        String[] builderCommand = getBuilderCommand(command);
        return runProcess(builderCommand, path, true);
    }
 
    public String runGitProcess(String args, String path) {
        String command = "git " + args;
        String[] builderCommand = getBuilderCommand(command);
        return runProcess(builderCommand, path, true);
    }

    public String[] getBuilderCommand(String command) {
        String[] builderCommand;
        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", command };
        } else {
            builderCommand = new String[] { "sh", "-c", command };
        }
        return builderCommand;
    }
    
    public int versionCompare(String str1, String str2) {
		try (Scanner s1 = new Scanner(str1);
				Scanner s2 = new Scanner(str2);) {
			s1.useDelimiter("\\.");
			s2.useDelimiter("\\.");

			while (s1.hasNextInt() && s2.hasNextInt()) {
				int v1 = s1.nextInt();
				int v2 = s2.nextInt();
				if (v1 < v2) {
					return -1;
				} else if (v1 > v2) {
					return 1;
				}
			}

			if (s1.hasNextInt() && s1.nextInt() != 0)
				return 1; //str1 has an additional lower-level version number
			if (s2.hasNextInt() && s2.nextInt() != 0)
				return -1; //str2 has an additional lower-level version

			return 0;
		} // end of try-with-resources
	}
}
