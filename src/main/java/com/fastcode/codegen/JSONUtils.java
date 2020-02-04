package com.fastcode.codegen;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

@Component
public class JSONUtils {
	
	public Object readJsonFile(String path) throws IOException, ParseException {
		JSONParser parser = new JSONParser();
		FileReader fr = new FileReader(path);
		Object obj = parser.parse(fr);
		fr.close(); 
		return obj;
	} 

	// type: "Object" , "Array"
	public String beautifyJson(Object jsonObject, String type)  {
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonParser jp = new JsonParser();
		JsonElement je;
		if(type == "Array") {
			je = jp.parse(((JSONArray)jsonObject).toJSONString());
		}
		else {
			je = jp.parse(((JSONObject)jsonObject).toJSONString());
		}
		return gson.toJson(je);
	}

	public void writeJsonToFile(String path, String jsonString) throws IOException {
		FileWriter file = new FileWriter(path);
		file.write(jsonString);
		file.close();
	}

}
