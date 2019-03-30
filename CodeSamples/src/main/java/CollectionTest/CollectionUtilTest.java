package CollectionTest;

import com.google.common.collect.Lists;
import org.apache.commons.collections4.CollectionUtils;

import java.util.List;

public class CollectionUtilTest {

    public static void main(String[] args) {

        List<String> a = Lists.newArrayList("a", "b", "c");
        List<String> b = Lists.newArrayList("b", "c", "d");

        System.out.println(CollectionUtils.disjunction(a, b));

    }
}
