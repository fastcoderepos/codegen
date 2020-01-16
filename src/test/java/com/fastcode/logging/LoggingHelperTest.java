package com.fastcode.logging;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
public class LoggingHelperTest {

	@InjectMocks
	private LoggingHelper logHelper;
	
	@Before 
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(logHelper);
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void getLogger_noParameterIsDefined_returnLogger()
	{
		Logger logger = LoggerFactory.getLogger(LoggingHelper.class);;
	
		Assertions.assertThat(logHelper.getLogger()).isEqualTo(logger);
	}
}