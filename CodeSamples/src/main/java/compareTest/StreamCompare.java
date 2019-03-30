package compareTest;

import com.google.common.collect.Lists;

import java.util.List;
import java.util.Optional;

public class StreamCompare {

    public static void main(String[] args) {
//        List<MyObj> allObjs = Lists.newArrayList(new MyObj(1l, "name1"), new MyObj(2l, "n2"), new MyObj(3l, "n3"));
//
//        System.out.println(allObjs.stream().min((item1, item2) -> item1.getId().compareTo(item2.getId())).get());
//

        List<Long> ss  = Lists.newArrayList();
        Optional<Long> a = ss.stream().findFirst();
        a.ifPresent(o -> System.out.println(o));

    }

}
