package kafka.utils;


import kafka.admin.AdminClient;
import kafka.coordinator.group.GroupOverview;
import org.apache.kafka.common.TopicPartition;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by szh on 2018/10/23.
 *
 * @author szh
 */
public class KafkaUtil {

    public static Set<String> getAllGroupsForTopic(String brokerListUrl, String topic) {

        AdminClient client = AdminClient.createSimplePlaintext(brokerListUrl);

        try {
            List<GroupOverview> allGroups = scala.collection.JavaConversions.seqAsJavaList(client.listAllGroupsFlattened().toSeq());
            Set<String> groups = new HashSet<>();
            for (GroupOverview overview : allGroups) {
                String groupID = overview.groupId();

                // 版本不匹配
                // org.apache.kafka.common.errors.UnsupportedVersionException: The broker only supports OffsetFetchRequest v1, but we need v2 or newer to request all topic partitions.
                // Map<TopicPartition, Object> offsets = scala.collection.JavaConversions.mapAsJavaMap(client.listGroupOffsets(groupID));

                Map<TopicPartition, Object> offsets = scala.collection.JavaConversions.mapAsJavaMap(client.listGroupOffsets(groupID));
                Set<TopicPartition> partitions = offsets.keySet();


                for (TopicPartition tp : partitions) {
                    if (tp.topic().equals(topic)) {
                        groups.add(groupID);
                    }
                }
            }
            return groups;
        } finally {
            client.close();
        }
    }

}
