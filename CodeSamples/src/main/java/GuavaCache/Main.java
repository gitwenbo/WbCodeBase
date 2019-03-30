package GuavaCache;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class Main {

//    @Autowired
    private static GuavaService guavaSerice;

//    @Autowired
//    ApplicationContext applicationContext;

    public static void main(String[] args) {

        ApplicationContext applicationContext = new AnnotationConfigApplicationContext(ContextConfig.class);
        guavaSerice = applicationContext.getBean(GuavaService.class);

        guavaSerice.filter("L", 2569l);
        guavaSerice.filter("M", 2538l);

        System.out.println(2569l + " : " + guavaSerice.filter("L", 2569l));
    }

}
