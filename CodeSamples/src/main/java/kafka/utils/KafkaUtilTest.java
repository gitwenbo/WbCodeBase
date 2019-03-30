package kafka.utils;

//import org.junit.Test;

import java.util.Set;

/**
 */
public class KafkaUtilTest {

//    @Test
    public void testGetAllGroupsForTopic() {

        Set<String> consumerSet = KafkaUtil.getAllGroupsForTopic("kafka-vs.coupang.net:9092", "cv.simil-cat-res.1");

        for (String tmp : consumerSet) {
            System.out.println(tmp);
        }
    }

}
