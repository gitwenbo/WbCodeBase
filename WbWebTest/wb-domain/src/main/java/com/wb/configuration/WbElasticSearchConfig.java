package com.wb.configuration;

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

@Configuration
public class WbElasticSearchConfig {
	@Value("#{'${elasticsearch.client.hosts}'.split(',')}")
	private List<String> esClientHosts;
	@Value("#{'${elasticsearch.master.hosts}'.split(',')}")
	private List<String> esMasterHosts;
	@Value("${elasticsearch.cluster.name}")
	private String clusterName;

	@Bean
	public TransportClient elasticsearchMasterTemplate() throws UnknownHostException {
		Settings settings = Settings.builder().put("cluster.name", clusterName).build();
		TransportClient client = new PreBuiltTransportClient(settings);
		for (String each : esMasterHosts) {
			String[] hostport = each.split(":");
			client.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(hostport[0]), Integer.parseInt(hostport[1])));
		}

		return client;
	}

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
}
