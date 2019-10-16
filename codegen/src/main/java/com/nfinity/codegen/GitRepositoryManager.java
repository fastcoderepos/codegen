package com.nfinity.codegen;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;


class GitRepositoryManager {
    private static String destinationPath = null;
    private static String command = null;
    private static String GIT_VERSION_NOT_ALLOW_MERGE_UNRELATED_HISTORIES = "2.9.0";
    private static String UPGRADE_BRANCH = "upgrade_application";
    static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
    static final String GIT_TEMPLATE_FOLDER = "/templates";



    public static void setDestinationPath(String path) {
        destinationPath = path;

    }

    public static boolean isGitInstalled() {

        command = "--version";
        String result = CommandUtils.runGitProcess(command , destinationPath);
        String regex = ".*?((?<!\\w)\\d+([.-]\\d+)*).*";
        result = result.replaceAll(regex, "$1");
        if(result == "") {
            System.out.print("\ngit is not found on your computer.");
            System.out.print("\nInstall git: \"https://git-scm.com/\"");
            return false;
        }
        return true;
    }

    public static Boolean isGitInitialized() {
        command = "rev-parse -q --is-inside-work-tree";
        String commandResult = CommandUtils.runGitProcess(command, destinationPath);
        return commandResult.trim().equalsIgnoreCase("true");
    }

    public static void initializeGit() {
        // Initialize directory as git repository
        command = "init";
        CommandUtils.runGitProcess(command, destinationPath);

        // Set required configuration
        command = "config --global user.name \"fastCode\"";
        CommandUtils.runGitProcess(command, destinationPath);

        command = "config --global user.email \"info@nfinityllc.com\"";
        CommandUtils.runGitProcess(command, destinationPath);
    }

    public static boolean hasUncommittedChanges() {
        //get git status
        command = "status --porcelain";
        String cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
        //Unable to check for local changes:
        //local changes found. Please commit/stash them before upgrading
        //return !cmdOutput.toLowerCase().contains("working tree clean");
        return !cmdOutput.isEmpty();
    }

    public static String getCurrentBranch() {
        command = "rev-parse -q --abbrev-ref HEAD";
        String cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
        //Unable to detect current Git branch
        return cmdOutput;
    }

    public static Boolean createUpgradeBranch() {
        command = "rev-parse -q --verify " + UPGRADE_BRANCH;
        String commandResult = CommandUtils.runGitProcess(command, destinationPath);
        if(commandResult.isEmpty()) {
            command = "checkout --orphan " + UPGRADE_BRANCH;
            String cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
            //Unable to create ${UPGRADE_BRANCH} branch:
            //Created branch ${UPGRADE_BRANCH}
        }
        return true;
    }

    static void addToGitRepository(Boolean doUpgrade, String sourceBranch) {
        if(!doUpgrade) {
            commitInitialApplication();
        }
        else {
            commitUpgradeBranch();
            command = "checkout -q " + sourceBranch;
            CommandUtils.runGitProcess(command, destinationPath);
            //Merging changes back to source branch...
            /*command = "merge -q " + UPGRADE_BRANCH;
            CommandUtils.runGitProcess(command, destinationPath);*/
            if(versionCompare(getGitVersion(),  GIT_VERSION_NOT_ALLOW_MERGE_UNRELATED_HISTORIES) == -1) {
                command = "merge --strategy=ours -q --no-edit " + UPGRADE_BRANCH;
            }
            else {
                command = "merge --allow-unrelated-histories " + UPGRADE_BRANCH;
            }
            CommandUtils.runGitProcess(command, destinationPath);
            //Check conflicts in package.json
            command = "diff --name-only --diff-filter=U package.json";
            String cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
            //There are conflicts in package.json, please fix them and then run npm install command ('npm install')
            //Check conflicts during merge
            command = "diff --name-only --diff-filter=U";
             cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
            //Please fix conflicts listed below and commit!
        }
    }

    public static void commitInitialApplication() {
        if(isGitInstalled() && isGitInitialized()) {
            command = "add -A";
            CommandUtils.runGitProcess(command, destinationPath);

            //TODO: Add version dynamically
            String commitMsg = "Initial application generated by fastCode-1.0";
            command = "commit -m \"" + commitMsg + "\"";
            CommandUtils.runGitProcess(command, destinationPath);
            System.out.print("Application successfully committed to Git.");
        }
        else {
            System.out.print("The generated application could not be committed to Git, as a Git repository could not be initialized.");
        }
    }

    private static void commitUpgradeBranch() {
        command = "add -A";
        CommandUtils.runGitProcess(command, destinationPath);
        //Unable to add resources in git:

        //TODO: Add version dynamically
        String commitMsg = "Generated with fastCode-1.0";
        command = "commit -q -m \"" + commitMsg + "\" -a --allow-empty --no-verify";
        CommandUtils.runGitProcess(command, destinationPath);
        System.out.print("Application successfully committed to Git.");
    }

    private static String getGitVersion() {
        //String(msg.match(/([0-9]+\.[0-9]+\.[0-9]+)/g))
        command = "--version";
        String cmdOutput = CommandUtils.runGitProcess(command, destinationPath);
        cmdOutput = cmdOutput.replaceAll(".*?((?<!\\w)\\d+([.-]\\d+)*).*", "$1");
        return cmdOutput;
    }
    private static int versionCompare(String str1, String str2) {
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
    private static void createMasterBranch() {
        command = "add *";
        CommandUtils.runGitProcess(command, destinationPath);

        command = "commit -m \"Initial code commit\"";
        CommandUtils.runGitProcess(command, destinationPath);
    }

    private static void mergeToMasterBranch() {
        // Create an orphan branch to stage the new changes
        command = "checkout --orphan upgrade_application";
        CommandUtils.runGitProcess(command, destinationPath);
        // Add all files to the upgrade branch
        command = "add *";
        CommandUtils.runGitProcess(command, destinationPath);
        // Commit the changes to the upgrade branch
        command = "commit -m \"Upgrade at \""
                + new java.text.SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date());
        CommandUtils.runGitProcess(command, destinationPath);
        // Switch to master branch for merging
        command = "checkout master";
        CommandUtils.runGitProcess(command, destinationPath);
        // Merge changes from Upgrade branch to master branch
        command = "merge --allow-unrelated-histories upgrade_application";
        CommandUtils.runGitProcess(command, destinationPath);
    }

    private static void deleteUpgradeBranchIfExists() {
        // Check if orphan branch exists
        command = "rev-parse --verify upgrade_application";
        String output = CommandUtils.runGitProcess(command, destinationPath);
        if (output.toLowerCase().contains("fatal")) {
            // Delete the branch since all the changes are merged and committed in the
            // master branch
            command = "branch -D upgrade_application";
            CommandUtils.runGitProcess(command, destinationPath);
        }
    }

    public static void CopyGitFiles() {
        ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, GIT_TEMPLATE_FOLDER + "/");
        TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl};
        MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
        cfg.setDefaultEncoding("UTF-8");
        cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
        cfg.setTemplateLoader(mtl);

        Map<String, Object> root = new HashMap<>();

        generateFiles(getGitTemplates(), root, destinationPath);

    }
    private static Map<String, Object> getGitTemplates() {
        Map<String, Object> gitTemplate = new HashMap<>();

        gitTemplate.put("gitignore.ftl", ".gitignore");

        return gitTemplate;
    }
    private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
        for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
            try {
                Template template = cfg.getTemplate(entry.getKey());

                String entryPath = entry.getValue().toString();
                File fileName = new File(destPath + "/" + entry.getValue().toString());

                String dirPath = destPath;
                if(destPath.split("/").length > 1 && entryPath.split("/").length > 1) {
                    dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
                }
                File dir = new File(dirPath);
                if(!dir.exists()) {
                    dir.mkdirs();
                };

                PrintWriter writer = new PrintWriter(fileName);
                template.process(root, writer);
                writer.flush();
                writer.close();

            } catch (Exception e1) {
                e1.printStackTrace();

            }
        }
    }
}
