package getSpecialVendorItems;

import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.search.SearchHits;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

public class EsUtils {

    @Autowired
//    @Qualifier("elasticsearchClientTemplate")
    private TransportClient subClient;
    private String indexName = "product-spark";
    private String typeName = "catalog-v2";

    public SearchHits search(QueryBuilder queryBuilder) {

        SearchResponse searchResponse =
                subClient.prepareSearch(this.indexName).setTypes(this.typeName).setQuery(queryBuilder).setSize(0).
                        execute().actionGet();

        return searchResponse.getHits();
    }



}
