package GuavaCache;

import com.google.common.collect.Maps;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;

@Component
public class GuavaService {

    private Map<String, Integer> cacheCount = Maps.newConcurrentMap();

//    @Cacheable(value = ContextConfig.CACHE_KEY_GARBAGE_FILTER)
//    public String filter(String name, Optional<Long> categoryId) {
//        return name;
//    }

    @Cacheable(value = ContextConfig.CACHE_KEY_GARBAGE_FILTER2)
    public String filter(String name, Long categoryId) {
        Integer count = cacheCount.get(name);
        count = count == null ? 0 : count;
        cacheCount.put(name, ++count);

        System.out.println(name + " / " + categoryId + " -- " + cacheCount.get(name));
        return name;
    }
}
