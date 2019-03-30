package getSpecialVendorItems;

import com.google.common.collect.Lists;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;


/**
 *     <entry key="elasticsearch.client.hosts">10.211.7.96:9300,10.211.7.241:9300,10.211.6.234:9300</entry>
 *     <entry key="elasticsearch.master.hosts">10.211.7.96:9300,10.211.7.241:9300,10.211.6.234:9300</entry>
 *     <entry key="elasticsearch.cluster.name">postdedup-prod</entry>
 *     <entry key="elasticsearch.catalogitem.alias">product-spark</entry>
 *     <entry key="elasticsearch.catalogitem.type">catalog-v2</entry>
 *
 *   <entry key="elasticsearch.productmatching.client.hosts">10.211.3.138:9300,10.211.6.187:9300,10.211.6.217:9300</entry>
 *   <entry key="elasticsearch.productmatching.cluster.name">productmatching-prod</entry>
 *   <entry key="elasticsearch.productmatching.phash.alias">item-features-phash</entry>
 *   <entry key="elasticsearch.productmatching.phash.type">phash</entry>
 */

@Configuration
public class ESConfig {
//	@Value("#{'${elasticsearch.client.hosts}'.split(',')}")
	private List<String> esClientHosts = Lists.newArrayList("10.211.3.78:9300","10.211.6.221:9300","10.211.6.89:9300");
//	@Value("#{'${elasticsearch.master.hosts}'.split(',')}")
	private List<String> esMasterHosts= Lists.newArrayList("10.211.7.96:9300","10.211.7.241:9300","10.211.6.234:9300");;
//	@Value("${elasticsearch.cluster.name}")
	private String clusterName = "product-spark-v3";

//	@Value("#{'${elasticsearch.productmatching.client.hosts}'.split(',')}")
//	private List<String> esProductionMatchingClientHosts;
//	@Value("${elasticsearch.productmatching.cluster.name}")
//	private String productmatchingClusterName;

//	@Bean
//	public TransportClient elasticsearchMasterTemplate() throws UnknownHostException {
//		Settings settings = Settings.builder().put("cluster.name", clusterName).build();
//		TransportClient client = new PreBuiltTransportClient(settings);
//		for (String each : esMasterHosts) {
//			String[] hostport = each.split(":");
//			client.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(hostport[0]), Integer.parseInt(hostport[1])));
//		}
//		return client;
//	}

	@Bean
	public TransportClient elasticsearchClientTemplate() throws UnknownHostException {
		Settings settings = Settings.builder().put("cluster.name", clusterName).build();
		TransportClient client = new PreBuiltTransportClient(settings);

		for (String each : esClientHosts) {
			String[] host_port = each.split(":");
			client.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(host_port[0]), Integer.parseInt(host_port[1])));
		}
		return client;
	}

//	@Bean
//	public TransportClient elasticsearchProductMatchingClientTemplate() throws UnknownHostException {
//		Settings settings = Settings.builder().put("cluster.name", productmatchingClusterName).build();
//		TransportClient client = new PreBuiltTransportClient(settings);
//
//		for (String each : esProductionMatchingClientHosts) {
//			String[] host_port = each.split(":");
//			client.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(host_port[0]), Integer.parseInt(host_port[1])));
//		}
//		return client;
//	}

}
