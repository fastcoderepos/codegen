package com.fastcode.entitycodegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;
import org.apache.openjpa.lib.util.Options;
import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.entitycodegen.ReverseMapping;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class ReverseMappingTest {

	@InjectMocks
	@Spy
	private ReverseMapping reverseMapping;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(reverseMapping);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		doNothing().when(loggerMock).info(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}

	@Test
	public void configureCommandLineArguments_setCommandlineArguemnts_returnStringArray() throws IOException, SQLException {
	
		Options opts = mock(Options.class);
		final String[] arguments = {};
		Mockito.when(opts.setFromCmdLine(any(String[].class))).thenReturn(arguments);
		Assertions.assertThat(reverseMapping.configureCommandLineArguments("testValue", "testValue", "testValue", opts)).isEqualTo(arguments);
		
	}

	@Test
	public void configureJdbc_propertiesMapIsValid_returnConfiguration()
	{
		Map<String,String> connectionProps = new HashMap<String, String>();
		connectionProps.put("url", "testValue");
		connectionProps.put("userName", "testValue");
		connectionProps.put("password", "testValue");
		connectionProps.put("driverName", "org.postgresql.Driver");
		JDBCConfiguration conf = new JDBCConfigurationImpl();

		conf.setConnectionURL(connectionProps.get("url"));
		conf.setConnectionUserName(connectionProps.get("username"));
		conf.setConnectionPassword(connectionProps.get("password"));
		conf.setConnectionDriverName("org.postgresql.Driver");
		
		Assertions.assertThat(reverseMapping.configureJdbc(connectionProps)).isEqualTo(conf);
	}

}
