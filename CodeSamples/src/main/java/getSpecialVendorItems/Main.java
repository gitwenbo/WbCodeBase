package getSpecialVendorItems;

import com.google.common.collect.Lists;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.util.List;

public class Main {

    private static String indexName = "product-spark";
    private static String typeName = "catalog-v2";


    public static void main(String[] args) {

        ApplicationContext applicationContext = new AnnotationConfigApplicationContext(ESConfig.class);
        TransportClient subClient = applicationContext.getBean("elasticsearchClientTemplate", TransportClient.class);

//        List<String> vendorIds = Lists.newArrayList("A00010028", "A00038294", "A00045899", "A00075170", "C00051747");
//        QueryBuilder queryBuilder = QueryBuilders.termsQuery("vendorIds", vendorIds);
        QueryBuilder queryBuilder = QueryBuilders.termsQuery("productId", Lists.newArrayList("142937415"));

        SearchResponse searchResponse =
                subClient.prepareSearch(indexName).setTypes(typeName).setQuery(queryBuilder).setFrom(0).setSize(10).
                        execute().actionGet();

    }

}
