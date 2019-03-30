package CollectionTest;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class IteratorTest {
    public static void main(String[] args) {
//        List<String> myList = new ArrayList<String>();
//        myList.add("a");
//        myList.add("b");
//        myList.add("c");
//
//        Iterator<String> iter = myList.iterator();
//        while (iter.hasNext()) {
//            String value = iter.next();
//            System.out.println(value);
//            if (value.equals("b")) {
//                iter.remove();
//            }
//        }

        double score = 0.9893519186973572;
        double a = (double) (Math.round(score * 100)) / 100;

        System.out.println(a);

    }
}
