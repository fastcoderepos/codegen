package com.fastcode.entitycodegen;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;

@Component
public class CGenClassLoader extends ClassLoader {
	
	 @Autowired
	 private LoggingHelper logHelper;
	 
	public  Map<String,String> retrieveClasses(Path rootDir, String packageName) throws IOException{
		Map<String,String> classFiles = new HashMap<String,String>();
		String packagePath =packageName==null? "" : packageName.replace('.', '/');
		Files.walkFileTree(rootDir, new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(
					Path file,
					BasicFileAttributes attrs) throws IOException {

				String filePath = file.toString().replace('\\', '/');
				if(filePath.endsWith(".class") && (packagePath==null || packagePath.isEmpty() || filePath.contains(packagePath)))
				{
					
					String qualifiedName =packagePath.isEmpty()? filePath.replace(rootDir.toString().replace('\\', '/') + "/" ,""):
						filePath.substring(filePath.indexOf(packagePath));      
					qualifiedName = qualifiedName.replace(".class","").replace("/",".");  
			
					classFiles.put(qualifiedName,filePath);
				}
			
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult postVisitDirectory(
					Path dir,
					IOException exc) throws IOException {

				return FileVisitResult.CONTINUE;
			}
		});
		return classFiles;
	}
	
	private static URLClassLoader classLoader;
	private static String path =".";

	public void setPath(String path) {
		this.path = path;
		
		try {
			classLoader = new URLClassLoader(new URL[]{new File(this.path).toURI().toURL()},Thread.currentThread().getContextClassLoader());
		} catch (MalformedURLException e) {
			logHelper.getLogger().error("Error Occured : ", e.getMessage());
		}
	}
	
//	@Override
//	public Class<?> findClass(String qualifiedClassName) throws ClassNotFoundException {
//
//			Class<?> loadedClass = classLoader.loadClass(qualifiedClassName);
//			return loadedClass;
//	}

	public ArrayList<Class<?>> findClasses(String packageName) throws ClassNotFoundException {

		try {        
			Map<String,String>  classFiles;
//			if(this.path.endsWith(".jar")){
//				classFiles= this.findClassesFromJar(packageName);
//			}
//			else {
					classFiles= retrieveClasses(Paths.get(this.path), packageName);
//			}
		
			ArrayList<Class<?>> classes = new ArrayList<Class<?>>();

			for (Map.Entry<String, String> entry : classFiles.entrySet()) {
				Class<?> cs = classLoader.loadClass( entry.getKey());

				classes.add(cs);
			}
			return classes;
		} catch (NullPointerException x) {
			logHelper.getLogger().error("Null Pointer Exception : ", x.getMessage());
			throw new ClassNotFoundException(packageName + " does not appear to be a valid package (Null pointer exception)");
		} 
		catch (IOException ioex) {
			logHelper.getLogger().error("IO Exception : ", ioex.getMessage());
			throw new ClassNotFoundException("IOException was thrown when trying to get all resources for " + packageName);
		}

	}  
	

//	private Map<String,String> findClassesFromJar(String packageName) {
//		try {          
//			String packagePath =packageName==null? "" : packageName.replace('.', '/');
//			System.out.println("ppk " + this.path);
//			JarFile jarFile = new JarFile(this.path);
//			System.out.println("ppk " + jarFile.getName());
//			Enumeration e = jarFile.entries();
//
//			Map<String,String>  classFiles = new HashMap<String,String>();
//			String qalifiedName;
//			while (e.hasMoreElements()) {
//				JarEntry je = (JarEntry) e.nextElement(); 
//				String filePath = je.getName();
//				
//				if(je.isDirectory() || (!packagePath.isEmpty() && !filePath.contains(packagePath))  || !filePath.endsWith(".class")){
//					continue;
//				}
//				qalifiedName = filePath.indexOf("classes/") > 0? filePath.substring(filePath.indexOf("classes/")+8):filePath;
//				qalifiedName = qalifiedName.replace(".class","").replace("/",".");             
//				qalifiedName = qalifiedName.replace(".class","").replace("/",".");     
//				classFiles.put(qalifiedName,filePath);
//				
//
//			}
//			jarFile.close();
//			return classFiles;
//		}
//		catch (Exception e) {
//			e.printStackTrace();
//			return null;
//		}
//
//	}

}