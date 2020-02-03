package com.fastcode.codegen;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.security.CodeSource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.RegexFileFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;

@Component
public class FolderContentReader {

	@Autowired
	private LoggingHelper logHelper;

	public List<String> getFilesFromFolder(String folderPath) {

		try {
			//	URI uri = Resources.getResource(folderPath).toURI();
			URI uri = FolderContentReader.class.getResource(folderPath).toURI();
			List<String> list = new ArrayList<String>(); 
			if (uri.getScheme().equals("jar")) {
				list = getFilesFromJar(folderPath); 
			} else {
				Collection<File> files = getFilesFromFileSystem(new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/"+ folderPath));
				for(File file:files) {
					if(file.isFile())
						list.add(file.getAbsolutePath());
				}
			}
			return list;

		}
		catch (IOException e) {
			logHelper.getLogger().error("IO Exception Occured while reading files", e.getMessage());
		}
		catch (URISyntaxException e) {
			logHelper.getLogger().error("URI syntax is not valid", e.getMessage());
		}
		return null;
	}

	public Collection<File> getFilesFromFileSystem(File path){
		Collection<File> files = FileUtils.listFilesAndDirs(
				path,
				new RegexFileFilter("^(.*?)"), 
				DirectoryFileFilter.DIRECTORY
				);

		return files;
	}


	public void copyFileFromJar(String fileName , String destinationPath)
	{
		try {
			URI uri;

			uri = FolderContentReader.class.getResource("/" + fileName).toURI();
			if (uri.getScheme().equals("jar")) {
				InputStream inputStream = FolderContentReader.class.getClassLoader().getResourceAsStream("classpath:/"+ fileName); 
				if(inputStream != null)
				{
					Files.copy(inputStream,Paths.get(destinationPath), StandardCopyOption.REPLACE_EXISTING);
				}
			}
			else 
			{
				Files.copy(Paths.get(uri), Paths.get(destinationPath), StandardCopyOption.REPLACE_EXISTING);

			}

		} catch (IOException e) {

			e.printStackTrace();
		}
		catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

//	public void copyDirectoryFromJar(String folder, String destinationPath)
//	{
//		try {
//			URI uri;
//			uri = FolderContentReader.class.getResource("/" +folder).toURI();
//			Path myPath;
//			if (uri.getScheme().equals("jar")) {
//				FileSystem fileSystem;
//
//				fileSystem = FileSystems.newFileSystem(uri, Collections.<String, Object>emptyMap());
//
//				System.out.println(" HEre " + uri.getPath() );
//				myPath = fileSystem.getPath("/resources"+folder);
//				fileSystem.close();
//			} else {
//				System.out.println(" HEre " + uri.getPath() );
//				myPath = Paths.get(uri);
//
//			}
//			Stream<Path> walk;
//
//			walk = Files.walk(myPath, 1);
//
//			for (Iterator<Path> it = walk.iterator(); it.hasNext();) {
//				Path p= it.next();
//				System.out.println(p + " \nfile name " + p.getFileName());
//				if(p.toFile().isFile())
//				{
//					copyFileFromJar(folder.concat("/" +p.getFileName().toString()),destinationPath);
//				}
//
//			}
//
//			walk.close();
//		} catch (URISyntaxException e1 ) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		}catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//
//
//	}

	public List<String> getFilesFromJar(String path) throws IOException{
		CodeSource src = this.getClass().getProtectionDomain().getCodeSource();
		List<String> list = new ArrayList<String>();
		if( src != null ) {
			java.net.URL jar = src.getLocation();
			ZipInputStream zip = new ZipInputStream( jar.openStream());
			ZipEntry ze = null;

			while( ( ze = zip.getNextEntry() ) != null ) {
				String entryName = ze.getName();

				if( entryName.startsWith("BOOT-INF/classes" + path + "/") && entryName.endsWith(".ftl") ) {
					list.add( entryName );
				}
			}
		}
		return list;
	}

}
