package com.wb.domain.cassandra;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Host;
import com.datastax.driver.core.KeyspaceMetadata;
import com.datastax.driver.core.Metadata;

import java.util.Optional;

public class HelloWorld {

    public static void main(String[] args) {
        String name="fff";
        Optional<Long> categoryId = Optional.ofNullable(null);
        String requestData = categoryId.map(Id -> "targetText=" + name + "&categoryId="+Id).orElse("targetText=" + name);
        System.out.println(requestData);

        Cluster cluster = Cluster.builder().addContactPoint("127.0.0.1").build();
        Metadata metadata = cluster.getMetadata();

        for (Host host : metadata.getAllHosts()) {
            System.out.println("==>" + host.getAddress());
        }

        System.out.println("===================");

        for (KeyspaceMetadata keyspaceMetadata : metadata.getKeyspaces()) {
            System.out.println("==>" + keyspaceMetadata.getName());
        }

        cluster.close();
    }

}
