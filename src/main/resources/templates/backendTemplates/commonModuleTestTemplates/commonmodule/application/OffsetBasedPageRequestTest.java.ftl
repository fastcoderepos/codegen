package [=PackageName].application;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.data.domain.Sort;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
public class OffsetBasedPageRequestTest {

	@Before 
	public void setUp() throws Exception {

	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void offestBasedPageRequest_offestIsLessThanZero_throwException()
	{
		
		try {
			new OffsetBasedPageRequest(-1, 1, new Sort(Sort.Direction.ASC, "id"));
        } catch (IllegalArgumentException ex) {
            Assertions.assertThat(ex.getMessage()).isEqualTo("Offset index must not be less than zero!");
        }
		
	}
	
	@Test
	public void offestBasedPageRequest_limitIsLessThanZero_throwException()
	{
		
		try {
			new OffsetBasedPageRequest(1, -1,new Sort(Sort.Direction.ASC, "id"));
        } catch (IllegalArgumentException ex) {
            Assertions.assertThat(ex.getMessage()).isEqualTo("Limit must not be less than one!");
        }
		
	}

}
