package GuavaCache.example;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
//import junit.framework.*;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

/**
 * *********************************************************
 * <p/>
 * Author:     XiJun.Gong
 * Date:       2016-08-17 16:59
 * Version:    default 1.0.0
 * Class description：
 * <p/>
 * *********************************************************
 */
public class CacheDemo {
    private static Cache<Object, Object> cache = CacheBuilder.newBuilder()
                                                             .maximumSize(100).expireAfterWrite(24, TimeUnit.HOURS)
                                                             .recordStats()
                                                             .build();

    public static Object get(Object key) throws ExecutionException {

        Object var = cache.get(key, new Callable<Object>() {
            @Override
            public Object call() throws Exception {
                System.out.println("如果没有值,就执行其他方式去获取值");
                String var = "Google.com.sg";
                return var;
            }
        });
        return var;
    }

    public static void put(Object key, Object value) {
        cache.put(key, value);
    }

    class Person {
        private String name;
        private Integer age;

        public Person() {
        }

        public Person(String name, Integer age) {
            this.name = name;
            this.age = age;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public Integer getAge() {
            return age;
        }

        public void setAge(Integer age) {
            this.age = age;
        }

        @Override
        public String toString() {
            return "Person{" +
                   "名字='" + name + '\'' +
                   ", 年纪=" + age +
                   '}';
        }
    }

//    @Test
    public void CacheTest() throws ExecutionException {

        Person person = new Person();
        person.setAge(11);
        person.setName("tSun");
        System.out.println(CacheDemo.get("man"));
        CacheDemo.put("man", new Person("hopg", 123));
        System.out.println(CacheDemo.get("man"));
        System.out.println(CacheDemo.get("man"));

        System.out.println(CacheDemo.get("person").toString());
        CacheDemo.put("person", person);
        System.out.println(CacheDemo.get("person").toString());
        System.out.println(CacheDemo.get("person").toString());

        System.out.println(CacheDemo.get("woman"));
        CacheDemo.put("women", new Person("google", 666));
        System.out.println(CacheDemo.get("woman"));
        System.out.println(CacheDemo.get("woman"));
        System.out.println(CacheDemo.get("man"));
    }
}