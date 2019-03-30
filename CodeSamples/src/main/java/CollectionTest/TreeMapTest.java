package CollectionTest;

import com.google.common.collect.Maps;

import java.util.Map;

public class TreeMapTest {

    public static void main(String[] args) {
        Map<Integer, Integer> testMap = Maps.newTreeMap();

        testMap.put(1, 5);
        testMap.put(5, 1);
        testMap.put(3, 6);
        testMap.put(2, 4);

        testMap.entrySet().forEach(each -> {
            System.out.println(each.getKey() + "-- " + each.getValue());
        });
    }
}
